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
      version: 2,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
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
        indications_ar TEXT NOT NULL DEFAULT '',
        indications_fr TEXT NOT NULL DEFAULT '',
        how_to_use_ar TEXT NOT NULL DEFAULT '',
        how_to_use_fr TEXT NOT NULL DEFAULT '',
        dosage TEXT NOT NULL DEFAULT '',
        prescription_required INTEGER DEFAULT 0,
        source TEXT DEFAULT 'seed'
      )
    ''');

    await db.execute('''
      CREATE TABLE medications_online(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        name_fr TEXT NOT NULL,
        price REAL NOT NULL,
        image_url TEXT,
        category TEXT NOT NULL,
        category_fr TEXT NOT NULL,
        indications_ar TEXT DEFAULT '',
        indications_fr TEXT DEFAULT '',
        how_to_use_ar TEXT DEFAULT '',
        how_to_use_fr TEXT DEFAULT '',
        dosage TEXT DEFAULT '',
        prescription_required INTEGER DEFAULT 0,
        source TEXT DEFAULT 'medicament_ma',
        form TEXT,
        packaging TEXT,
        manufacturer TEXT,
        detail_url TEXT,
        price_hospital REAL,
        price_para REAL
      )
    ''');

    await db.execute(
      'CREATE INDEX idx_online_name ON medications_online(name_fr)',
    );
    await db.execute(
      'CREATE INDEX idx_online_category ON medications_online(category_fr)',
    );

    await _seedData(db);
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('''
        CREATE TABLE IF NOT EXISTS medications_online(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT NOT NULL,
          name_fr TEXT NOT NULL,
          price REAL NOT NULL,
          image_url TEXT,
          category TEXT NOT NULL,
          category_fr TEXT NOT NULL,
          indications_ar TEXT DEFAULT '',
          indications_fr TEXT DEFAULT '',
          how_to_use_ar TEXT DEFAULT '',
          how_to_use_fr TEXT DEFAULT '',
          dosage TEXT DEFAULT '',
          prescription_required INTEGER DEFAULT 0,
          source TEXT DEFAULT 'medicament_ma',
          form TEXT,
          packaging TEXT,
          manufacturer TEXT,
          detail_url TEXT,
          price_hospital REAL,
          price_para REAL
        )
      ''');

      await db.execute(
        'CREATE INDEX IF NOT EXISTS idx_online_name ON medications_online(name_fr)',
      );
      await db.execute(
        'CREATE INDEX IF NOT EXISTS idx_online_category ON medications_online(category_fr)',
      );

      // Add source column to existing medications table if missing
      try {
        await db.execute(
          "ALTER TABLE medications ADD COLUMN source TEXT DEFAULT 'seed'",
        );
      } catch (_) {
        // Column already exists
      }
    }
  }

  Future<void> _seedData(Database db) async {
    final medications = SeedData.getMedications();
    final batch = db.batch();
    for (final med in medications) {
      batch.insert('medications', med.toMap());
    }
    await batch.commit(noResult: true);
  }

  // Seed medications (detailed bilingual data)
  Future<List<Medication>> getAllMedications() async {
    final db = await database;
    final maps = await db.query('medications');
    return maps.map((map) => Medication.fromMap(map)).toList();
  }

  // Online medications from medicament.ma
  Future<List<Medication>> getOnlineMedications() async {
    final db = await database;
    final maps = await db.query('medications_online');
    return maps.map((map) => Medication.fromMap(map)).toList();
  }

  Future<int> getOnlineMedicationCount() async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM medications_online',
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }

  // All medications combined
  Future<List<Medication>> getAllCombinedMedications() async {
    final seed = await getAllMedications();
    final online = await getOnlineMedications();
    return [...seed, ...online];
  }

  Future<List<Medication>> searchAllMedications(String query) async {
    final db = await database;
    final seedMaps = await db.query(
      'medications',
      where:
          'name LIKE ? OR name_fr LIKE ? OR category LIKE ? OR category_fr LIKE ?',
      whereArgs: ['%$query%', '%$query%', '%$query%', '%$query%'],
    );
    final onlineMaps = await db.query(
      'medications_online',
      where:
          'name LIKE ? OR name_fr LIKE ? OR manufacturer LIKE ? OR category_fr LIKE ?',
      whereArgs: ['%$query%', '%$query%', '%$query%', '%$query%'],
    );
    return [
      ...seedMaps.map((m) => Medication.fromMap(m)),
      ...onlineMaps.map((m) => Medication.fromMap(m)),
    ];
  }

  Future<void> clearOnlineMedications() async {
    final db = await database;
    await db.delete('medications_online');
  }

  Future<void> insertOnlineMedications(List<Medication> medications) async {
    final db = await database;
    final batch = db.batch();
    for (final med in medications) {
      batch.insert('medications_online', med.toMap());
    }
    await batch.commit(noResult: true);
  }

  Future<List<String>> getCategories() async {
    final db = await database;
    final maps = await db.rawQuery(
      'SELECT DISTINCT category FROM medications',
    );
    return maps.map((map) => map['category'] as String).toList();
  }

  Future<List<String>> getCategoriesFr() async {
    final db = await database;
    final seedCats = await db.rawQuery(
      'SELECT DISTINCT category_fr FROM medications',
    );
    final onlineCats = await db.rawQuery(
      'SELECT DISTINCT category_fr FROM medications_online',
    );
    final allCats = <String>{};
    for (final m in seedCats) {
      allCats.add(m['category_fr'] as String);
    }
    for (final m in onlineCats) {
      allCats.add(m['category_fr'] as String);
    }
    return allCats.toList();
  }

  Future<List<String>> getAllCategories() async {
    final db = await database;
    final seedCats = await db.rawQuery(
      'SELECT DISTINCT category FROM medications',
    );
    final onlineCats = await db.rawQuery(
      'SELECT DISTINCT category FROM medications_online',
    );
    final allCats = <String>{};
    for (final m in seedCats) {
      allCats.add(m['category'] as String);
    }
    for (final m in onlineCats) {
      allCats.add(m['category'] as String);
    }
    return allCats.toList();
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
