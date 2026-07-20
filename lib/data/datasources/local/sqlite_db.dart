import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../../models/ir_device_model.dart';

class SQLiteDB {
  static final SQLiteDB instance = SQLiteDB._init();
  static Database? _database;

  SQLiteDB._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('ir_remotes.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const integerType = 'INTEGER NOT NULL';

    await db.execute('''
CREATE TABLE devices (
  id $idType,
  category $textType,
  brand $textType,
  series $textType,
  model $textType,
  carrierFrequency $integerType,
  buttons $textType
  )
''');
  }

  Future<void> insertDevice(IrDeviceModel device) async {
    final db = await instance.database;
    final data = {
      'category': device.category,
      'brand': device.brand,
      'series': device.series,
      'model': device.model,
      'carrierFrequency': device.carrierFrequency,
      'buttons': jsonEncode(device.buttons),
    };
    await db.insert('devices', data, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<String>> getBrandsByCategory(String category) async {
    final db = await instance.database;
    final result = await db.query(
      'devices',
      distinct: true,
      columns: ['brand'],
      where: 'category = ?',
      whereArgs: [category],
    );
    return result.map((e) => e['brand'] as String).toList();
  }

  Future<List<IrDeviceModel>> getDevicesByBrand(String brand) async {
    final db = await instance.database;
    final result = await db.query(
      'devices',
      where: 'brand = ?',
      whereArgs: [brand],
    );

    return result.map((json) {
      final buttonsStr = json['buttons'] as String;
      final buttonsMap = Map<String, List<dynamic>>.from(jsonDecode(buttonsStr));
      final typedButtonsMap = buttonsMap.map((key, value) => MapEntry(key, value.map((e) => e as int).toList()));
      
      return IrDeviceModel(
        id: json['id'] as int,
        category: json['category'] as String,
        brand: json['brand'] as String,
        series: json['series'] as String,
        model: json['model'] as String,
        carrierFrequency: json['carrierFrequency'] as int,
        buttons: typedButtonsMap,
      );
    }).toList();
  }
}
