import 'dart:async';
import 'dart:io' show Directory;
import 'package:sqflite/sqflite.dart';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart' show getApplicationDocumentsDirectory;
import 'package:egfr_calculator/Classes/AccountsClass.dart';
import 'package:egfr_calculator/Classes/ProfileClass.dart';


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
    String path = join(documentsDirectory.path, "egfr.db");
    return await openDatabase(path,
        version: _version,
        onCreate: _create);
  }

  Future _create(Database db, int version) async {

    db.execute("CREATE TABLE accounts(email TEXT PRIMARY KEY, password TEXT)");
    db.execute("CREATE TABLE profiles(name TEXT PRIMARY KEY, dob TEXT, gender INT, ethnicity INT, account TEXT)");

  }

  Future<void> insertAccount(Account account) async {
    final Database db =await database;
    await db.insert(
      'accounts',
      account.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    ).catchError((error) {
      print("Something went wrong: ${error.message}");
    });
  }

  Future<void> insertProfile(Profile profile) async {
    final Database db =await database;
    await db.insert(
      'profiles',
      profile.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    ).catchError((error) {
      print("Something went wrong: ${error.message}");
    });
    print("Inserting "+ profile.getName());
  }

  Future<List<Profile>> getAllProfiles(String email) async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('profiles',where: "account = ?",whereArgs: [email]);
    return List.generate(maps.length, (i) {
      return Profile(
          name: maps[i]['name'],
          dob: maps[i]['dob'],
          gender: maps[i]['gender'],
          ethnicity: maps[i]['ethnicity'],
          account: maps[i]['account']
      );
    });
  }

  Future<Account> getSpecificAccount(String name) async {
    final Database db = await database;
    // final List<Map<String, dynamic>> maps =  await db.rawQuery('SELECT * FROM Symptom WHERE name=?',[name]);
    final List<Map<String, dynamic>> maps = await db.query("accounts",where: "email = ?",whereArgs: [name]);
    List<Account> list =  List.generate(maps.length, (i) {
      return Account(
          email: maps[i]['email'],
          password: maps[i]['password'],
      );
    });
    if(list != null && list.isNotEmpty){
      return list[0];
    }
    else{
      return null;
    }
  }
}

