import 'package:flutter/foundation.dart';
import '../models/medication.dart';
import 'database_helper.dart';
import 'seed_data.dart';

class MedicationRepository {
  static final MedicationRepository _instance =
      MedicationRepository._internal();
  factory MedicationRepository() => _instance;
  MedicationRepository._internal();

  List<Medication>? _memoryMedications;
  bool _useFallback = false;

  Future<void> initialize() async {
    if (kIsWeb) {
      _useFallback = true;
      _memoryMedications = SeedData.getMedications();
      return;
    }

    try {
      final db = DatabaseHelper();
      final meds = await db.getAllMedications();
      if (meds.isEmpty) {
        _useFallback = true;
        _memoryMedications = SeedData.getMedications();
      }
    } catch (e) {
      _useFallback = true;
      _memoryMedications = SeedData.getMedications();
    }
  }

  Future<List<Medication>> getAllMedications() async {
    if (_useFallback) {
      return _memoryMedications ?? SeedData.getMedications();
    }
    try {
      return await DatabaseHelper().getAllMedications();
    } catch (e) {
      _useFallback = true;
      _memoryMedications = SeedData.getMedications();
      return _memoryMedications!;
    }
  }

  Future<List<Medication>> searchMedications(String query) async {
    final all = await getAllMedications();
    if (query.isEmpty) return all;
    final q = query.toLowerCase();
    return all.where((med) {
      return med.name.toLowerCase().contains(q) ||
          med.nameFr.toLowerCase().contains(q) ||
          med.category.contains(query) ||
          med.categoryFr.toLowerCase().contains(q);
    }).toList();
  }

  Future<List<Medication>> getMedicationsByCategory(String category) async {
    final all = await getAllMedications();
    return all
        .where(
            (med) => med.category == category || med.categoryFr == category)
        .toList();
  }

  Future<List<String>> getCategories() async {
    final all = await getAllMedications();
    return all.map((m) => m.category).toSet().toList();
  }

  Future<List<String>> getCategoriesFr() async {
    final all = await getAllMedications();
    return all.map((m) => m.categoryFr).toSet().toList();
  }

  Future<Medication?> getMedicationById(int id) async {
    final all = await getAllMedications();
    try {
      return all.firstWhere((m) => m.id == id);
    } catch (_) {
      return null;
    }
  }
}
