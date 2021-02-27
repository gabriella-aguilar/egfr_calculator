import 'dart:async';
import 'dart:io' show Directory;
import 'package:egfr_calculator/Classes/CalculationClass.dart';
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

    db.execute("CREATE TABLE accounts(email TEXT PRIMARY KEY, password TEXT, unit INT)");
    db.execute("CREATE TABLE profiles(name TEXT, dob TEXT, gender INT, ethnicity INT, account TEXT, PRIMARY KEY(name,account))");
    db.execute("CREATE TABLE calculations(date TEXT, egfr REAL, account TEXT, profile TEXT)");

  }

  Future<void> insertCalculation(Calculation calculation) async {
    final Database db =await database;
    await db.insert(
      'calculations',
      calculation.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    ).catchError((error) {
      print("Something went wrong: ${error.message}");
    });
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

  Future<List<Calculation>> getCalculations(String account, String profile) async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('calculations',where: "account = ? AND profile = ?",whereArgs: [account,profile]);
    return List.generate(maps.length, (i) {
      return Calculation(
          date: maps[i]['date'],
          egfr: maps[i]['egfr'],
          profile: maps[i]['profile'],
          account: maps[i]['account']
      );
    });
  }

  Future<Account> getSpecificAccount(String name) async {
    final Database db = await database;
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

  void deleteCalculation(String date,String profile,String account) async{
    final Database db = await database;
    db.delete('calculations',where: "date = ? AND profile = ? AND account = ?" ,whereArgs: [date,profile,account]);
  }

  void deleteProfile(String profile,String account) async{
    final Database db = await database;
    db.delete('profiles',where: "name = ? AND account = ?" ,whereArgs: [profile,account]);
    db.delete('calculations',where: "profile = ? AND account = ?" ,whereArgs: [profile,account]);
  }

  void updateUnit(Account account) async{
    final Database db = await database;
    String email = account.getEmail();
    Map<String,dynamic> row = account.toMap();

    await db.update('accounts', row, where: "email = ?", whereArgs: [email]);
  }

  void updateProfile(String name, String account, Profile newProfile) async{
    final Database db = await database;
    Map<String,dynamic> row = newProfile.toMap();
    await db.update('profiles', row, where: "name = ? AND account = ?",whereArgs: [name,account]);
  }

}

