import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/walk.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._();
  static Database? _db;

  DatabaseHelper._();

  Future<Database> get db async => _db ??= await _initDb();

  Future<Database> _initDb() async {
    final path = join(await getDatabasesPath(), 'walks.db');
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE walks (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        date TEXT,
        distanceMeters REAL
      )
    ''');
  }

  Future<int> insertWalk(Walk walk) async {
    final dbClient = await db;
    return await dbClient.insert('walks', walk.toMap());
  }

  Future<List<Walk>> getAllWalks() async {
    final dbClient = await db;
    final maps = await dbClient.query('walks', orderBy: 'date DESC');
    return maps.map((map) => Walk.fromMap(map)).toList();
  }
}
