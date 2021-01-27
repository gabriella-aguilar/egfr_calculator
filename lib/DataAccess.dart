import 'dart:async';
import 'dart:io' show Directory;
import 'package:sqflite/sqflite.dart';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart' show getApplicationDocumentsDirectory;


class DataAccess{
  int _version = 2;

  DataAccess._privateConstructor();
  static final DataAccess instance = DataAccess._privateConstructor();

  static Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;

    _database = await _initDatabase();
    // _create(_database, _version);

    return _database;
  }

  _initDatabase () async{
    WidgetsFlutterBinding.ensureInitialized();

    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "tracking.db");
    return await openDatabase(path,
        version: _version,
        onCreate: _create);
  }

  Future _create(Database db, int version) async {

    db.execute("CREATE TABLE account(email TEXT PRIMARY KEY, password TEXT)");
    db.execute("CREATE TABLE profiles(name TEXT PRIMARY KEY, dob TEXT, ethnicity INT, account TEXT)");

  }





}

