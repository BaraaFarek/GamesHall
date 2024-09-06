import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../domain/entities/device.dart';

class DeviceDatabase {
  static final DeviceDatabase instance = DeviceDatabase._init();
  static Database? _database;

  DeviceDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('devices.db');
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
    await db.execute('''
      CREATE TABLE devices (
        id TEXT PRIMARY KEY,
        name TEXT,
        type TEXT,
        status TEXT,
        pricePerHour REAL
      )
    ''');
  }

  Future<void> addDevice(Device device) async {
    final db = await instance.database;
    await db.insert('devices', device.toJson());
  }

  Future<void> updateDevice(Device device) async {
    final db = await instance.database;
    await db.update(
      'devices',
      device.toJson(),
      where: 'id = ?',
      whereArgs: [device.id],
    );
  }

  Future<void> removeDevice(String id) async {
    final db = await instance.database;
    await db.delete(
      'devices',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<Device>> fetchDevices() async {
    final db = await instance.database;
    final result = await db.query('devices');
    return result.map((json) => Device.fromJson(json)).toList();
  }
}
