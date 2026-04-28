import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/medication.dart';
import 'seed_data.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'pharma_ma.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE medications(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        name_fr TEXT NOT NULL,
        price REAL NOT NULL,
        image_url TEXT,
        category TEXT NOT NULL,
        category_fr TEXT NOT NULL,
        indications_ar TEXT NOT NULL,
        indications_fr TEXT NOT NULL,
        how_to_use_ar TEXT NOT NULL,
        how_to_use_fr TEXT NOT NULL,
        dosage TEXT NOT NULL,
        prescription_required INTEGER DEFAULT 0
      )
    ''');

    await _seedData(db);
  }

  Future<void> _seedData(Database db) async {
    final medications = SeedData.getMedications();
    final batch = db.batch();
    for (final med in medications) {
      batch.insert('medications', med.toMap());
    }
    await batch.commit(noResult: true);
  }

  Future<List<Medication>> getAllMedications() async {
    final db = await database;
    final maps = await db.query('medications');
    return maps.map((map) => Medication.fromMap(map)).toList();
  }

  Future<List<Medication>> searchMedications(String query) async {
    final db = await database;
    final maps = await db.query(
      'medications',
      where: 'name LIKE ? OR name_fr LIKE ? OR category LIKE ? OR category_fr LIKE ?',
      whereArgs: ['%$query%', '%$query%', '%$query%', '%$query%'],
    );
    return maps.map((map) => Medication.fromMap(map)).toList();
  }

  Future<List<Medication>> getMedicationsByCategory(String category) async {
    final db = await database;
    final maps = await db.query(
      'medications',
      where: 'category = ? OR category_fr = ?',
      whereArgs: [category, category],
    );
    return maps.map((map) => Medication.fromMap(map)).toList();
  }

  Future<List<String>> getCategories() async {
    final db = await database;
    final maps = await db.rawQuery('SELECT DISTINCT category, category_fr FROM medications');
    return maps.map((map) => map['category'] as String).toList();
  }

  Future<List<String>> getCategoriesFr() async {
    final db = await database;
    final maps = await db.rawQuery('SELECT DISTINCT category_fr FROM medications');
    return maps.map((map) => map['category_fr'] as String).toList();
  }

  Future<Medication?> getMedicationById(int id) async {
    final db = await database;
    final maps = await db.query(
      'medications',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return Medication.fromMap(maps.first);
    }
    return null;
  }

  Future<int> insertMedication(Medication medication) async {
    final db = await database;
    return await db.insert('medications', medication.toMap());
  }
}
