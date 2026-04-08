import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

import '../../core/constants/app_constants.dart';
import '../../core/utils/date_utils.dart';
import '../../core/utils/notification_service.dart';
import '../models/medicine_model.dart';

class MedicineProvider extends ChangeNotifier {
  late Box<MedicineModel> _medicineBox;
  late Box<MedicineDose> _doseBox;
  final _uuid = const Uuid();

  List<MedicineModel> _medicines = [];
  List<MedicineDose> _doses = [];

  MedicineProvider() {
    _medicineBox = Hive.box<MedicineModel>(AppConstants.medicineBox);
    _doseBox = Hive.box<MedicineDose>(AppConstants.medicineDoseBox);
    _loadData();
  }

  List<MedicineModel> get medicines => List.unmodifiable(_medicines);
  List<MedicineModel> get activeMedicines =>
      _medicines.where((m) => m.isActive).toList();

  List<MedicineDose> get todayDoses {
    final today = AppDateUtils.dateOnly(DateTime.now());
    return _doses.where((d) {
      return AppDateUtils.isSameDay(d.scheduledTime, today);
    }).toList()
      ..sort((a, b) => a.scheduledTime.compareTo(b.scheduledTime));
  }

  int get todayTakenCount => todayDoses.where((d) => d.taken).length;
  int get todayTotalCount => todayDoses.length;

  double get todayCompletionRate {
    if (todayTotalCount == 0) return 0;
    return todayTakenCount / todayTotalCount;
  }

  void _loadData() {
    _medicines = _medicineBox.values.toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    _doses = _doseBox.values.toList();
    notifyListeners();
  }

  Future<void> addMedicine({
    required String name,
    String? dosage,
    required List<String> times,
    String? notes,
  }) async {
    final id = _uuid.v4();
    final medicine = MedicineModel(
      id: id,
      name: name,
      dosage: dosage,
      times: times,
      notes: notes,
      createdAt: DateTime.now(),
    );
    await _medicineBox.add(medicine);

    // Schedule notifications for each time
    await _scheduleNotifications(medicine);

    // Create today's doses
    await _createDosesForToday(medicine);

    _loadData();
  }

  Future<void> updateMedicine(MedicineModel medicine) async {
    await medicine.save();
    // Reschedule notifications
    await _cancelNotifications(medicine.id);
    if (medicine.isActive) {
      await _scheduleNotifications(medicine);
    }
    _loadData();
  }

  Future<void> toggleMedicineActive(String medicineId) async {
    final index = _medicines.indexWhere((m) => m.id == medicineId);
    if (index == -1) return;

    final medicine = _medicines[index];
    final updated = medicine.copyWith(isActive: !medicine.isActive);

    // Delete old and save new
    await medicine.delete();
    await _medicineBox.add(updated);

    if (updated.isActive) {
      await _scheduleNotifications(updated);
    } else {
      await _cancelNotifications(updated.id);
    }
    _loadData();
  }

  Future<void> deleteMedicine(String medicineId) async {
    final index = _medicines.indexWhere((m) => m.id == medicineId);
    if (index != -1) {
      await _cancelNotifications(medicineId);
      await _medicines[index].delete();
      // Delete associated doses
      final dosesToDelete = _doses.where((d) => d.medicineId == medicineId);
      for (final dose in dosesToDelete) {
        await dose.delete();
      }
      _loadData();
    }
  }

  Future<void> markDoseTaken(String doseId) async {
    final index = _doses.indexWhere((d) => d.id == doseId);
    if (index != -1) {
      final oldDose = _doses[index];
      final newDose = MedicineDose(
        id: oldDose.id,
        medicineId: oldDose.medicineId,
        scheduledTime: oldDose.scheduledTime,
        taken: true,
        takenAt: DateTime.now(),
      );
      await oldDose.delete();
      await _doseBox.add(newDose);
      _loadData();
    }
  }

  Future<void> markDoseMissed(String doseId) async {
    final index = _doses.indexWhere((d) => d.id == doseId);
    if (index != -1) {
      final oldDose = _doses[index];
      final newDose = MedicineDose(
        id: oldDose.id,
        medicineId: oldDose.medicineId,
        scheduledTime: oldDose.scheduledTime,
        taken: false,
        takenAt: null,
      );
      await oldDose.delete();
      await _doseBox.add(newDose);
      _loadData();
    }
  }

  /// Create dose entries for today for a given medicine
  Future<void> _createDosesForToday(MedicineModel medicine) async {
    final today = DateTime.now();
    for (final timeStr in medicine.times) {
      final parts = timeStr.split(':');
      final hour = int.parse(parts[0]);
      final minute = int.parse(parts[1]);
      final scheduledTime = DateTime(
        today.year, today.month, today.day, hour, minute,
      );

      // Check if dose already exists
      final exists = _doseBox.values.any((d) =>
          d.medicineId == medicine.id &&
          AppDateUtils.isSameDay(d.scheduledTime, today) &&
          d.scheduledTime.hour == hour &&
          d.scheduledTime.minute == minute);

      if (!exists) {
        await _doseBox.add(MedicineDose(
          id: _uuid.v4(),
          medicineId: medicine.id,
          scheduledTime: scheduledTime,
        ));
      }
    }
  }

  /// Ensure today's doses exist for all active medicines
  Future<void> ensureTodayDoses() async {
    for (final medicine in activeMedicines) {
      await _createDosesForToday(medicine);
    }
    _loadData();
  }

  Future<void> _scheduleNotifications(MedicineModel medicine) async {
    for (int i = 0; i < medicine.times.length; i++) {
      final parts = medicine.times[i].split(':');
      final hour = int.parse(parts[0]);
      final minute = int.parse(parts[1]);

      await NotificationService.instance.scheduleDailyNotification(
        id: medicine.id.hashCode + i,
        title: 'Medicine Reminder',
        body: 'Time to take ${medicine.name}${medicine.dosage != null ? " (${medicine.dosage})" : ""}',
        hour: hour,
        minute: minute,
        payload: 'medicine_${medicine.id}',
      );
    }
  }

  Future<void> _cancelNotifications(String medicineId) async {
    // Cancel all possible notification IDs for this medicine
    for (int i = 0; i < 10; i++) {
      await NotificationService.instance
          .cancelNotification(medicineId.hashCode + i);
    }
  }

  /// Get medicine name by ID
  String getMedicineName(String medicineId) {
    final medicine = _medicines.where((m) => m.id == medicineId).firstOrNull;
    return medicine?.name ?? 'Unknown';
  }
}
