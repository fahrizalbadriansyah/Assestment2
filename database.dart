import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:async';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class DatabaseHelper {
  static DatabaseFactory? _databaseFactory;
  static Database? _database;
  static const String dbName = 'opangatimin.db';

  // Initialize the databaseFactory
  static void initDatabaseFactory() {
    if (_databaseFactory == null) {
      _databaseFactory = databaseFactoryFfi;
    }
  }

  Future<Database> get database async {
    // Ensure databaseFactory is initialized
    initDatabaseFactory();

    if (_database == null) {
      _database = await initDatabase();
    }

    return _database!;
  }

  Future<Database> initDatabase() async {
    String path = join(await getDatabasesPath(), dbName);

    return await openDatabase(path, version: 1, onCreate: _createDb);
  }

  Future<void> _createDb(Database db, int version) async {
    await db.execute('''
      CREATE TABLE tukangojek(
        id INTEGER PRIMARY KEY,
        nama TEXT,
        nopol TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE transaksi(
        id INTEGER PRIMARY KEY,
        tukangojek_id INTEGER,
        harga INTEGER,
        timestamp TEXT,
        FOREIGN KEY (tukangojek_id) REFERENCES tukangojek (id)
      )
    ''');
  }

  Future<int> insertTukangOjek(String nama, String nopol) async {
    Database db = await database;
    return await db.insert('tukangojek', {'nama': nama, 'nopol': nopol});
  }

  Future<int> insertTransaksi(int tukangOjekId, int harga) async {
    Database db = await database;
    DateTime timestamp = DateTime.now();
    String timestampString = timestamp.toIso8601String();

    return await db.insert('transaksi', {'tukangojek_id': tukangOjekId, 'harga': harga, 'timestamp': timestampString});
  }

  Future<List<Map<String, dynamic>>> getTukangOjekStats({String sortField = 'nama'}) async {
    Database db = await database;

    String orderBy;
    if (sortField == 'orderCount') {
      orderBy = 'jumlahOrder DESC';
    } else {
      orderBy = sortField;
    }

    return await db.rawQuery('''
      SELECT tukangojek.id, tukangojek.nama, tukangojek.nopol, 
      COUNT(transaksi.id) AS jumlahOrder, 
      SUM(transaksi.harga) AS omzet
      FROM tukangojek
      LEFT JOIN transaksi ON tukangojek.id = transaksi.tukangojek_id
      GROUP BY tukangojek.id
      ORDER BY $orderBy
    ''');
  }
}