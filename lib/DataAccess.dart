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
    db.execute("CREATE TABLE calculations(date TEXT, egfr REAL, account TEXT, profile TEXT, PRIMARY KEY(date,profile,account))");
    db.execute("CREATE TABLE styles(name TEXT, num INT, account TEXT, PRIMARY KEY(name,account))");
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
    db.rawInsert("INSERT INTO styles (name,num,account) VALUES ('fontShift',0,?);",[account.getEmail()]);
    db.rawInsert("INSERT INTO styles (name,num,account) VALUES ('palette',0,?);",[account.getEmail()]);
  }


  void updateFontSize(String account,int fontSize) async{
    final Database db = await database;
    Map<String,dynamic> row = {'name':'fontShift','num':fontSize,'account':account};
    await db.update('styles', row, where: "name = 'fontShift' AND account = ?",whereArgs: [account]);
  }

  void updatePalette(String account,int palette) async{
    final Database db = await database;
    Map<String,dynamic> row = {'name':'palette','num':palette,'account':account};
    await db.update('styles', row, where: "name = 'palette' AND account = ?",whereArgs: [account]);
  }

  Future<int> getFontSize(String account) async {
    final Database db =await database;
    final List<Map<String, dynamic>> maps = await db.query('styles',where: "name = 'fontShift' AND account = ?",whereArgs: [account]);
    return maps[0]['num'];
  }

  Future<int> getPalette(String account) async {
    final Database db =await database;
    final List<Map<String, dynamic>> maps = await db.query('styles',where: "name = 'palette' AND account = ?",whereArgs: [account]);
    return maps[0]['num'];
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

  Future<List<Account>> getAllAccounts() async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('accounts');
    return List.generate(maps.length, (i) {
      return Account(
          email: maps[i]['email'],
          password: maps[i]['password'],
          unit: maps[i]['unit'],
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
          unit: maps[i]['unit']
      );
    });
    if(list != null && list.isNotEmpty){
      return list[0];
    }
    else{
      return null;
    }
  }

  Future<Profile> getSpecificProfile(String account, String name) async{
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query("profiles",where: "account = ? AND name = ?",whereArgs: [account,name]);
    List<Profile> list = List.generate(maps.length, (i) {
      return Profile(
          name: maps[i]['name'],
          dob: maps[i]['dob'],
          gender: maps[i]['gender'],
          ethnicity: maps[i]['ethnicity'],
          account: maps[i]['account']
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
    print('inside update unit');
    final Database db = await database;
    String email = account.getEmail();
    Map<String,dynamic> row = account.toMap();

    await db.update('accounts', row, where: "email = ?", whereArgs: [email]);
  }

  void updateProfile(String name, String account, Profile newProfile) async{
    String newName = newProfile.getName();
    final Database db = await database;
    Map<String,dynamic> row = newProfile.toMap();
    await db.update('profiles', row, where: "name = ? AND account = ?",whereArgs: [name,account]);

    if(name != newName){
      updateCalc(account, name, newName);
    }
  }

  void updateCalc(String email, String oldName, String newName) async{
    List<Calculation> calcs = await getCalculations(email, oldName);
    List<Calculation> newCalcs = List();
    calcs.forEach((element) {
      newCalcs.add(new Calculation(
        date: element.getDate(),
        egfr: element.getEgfr(),
        account: element.getAccount(),
        profile: newName
      ));
      deleteCalculation(element.getDate(), oldName, element.getAccount());
    });

    newCalcs.forEach((element) {
      insertCalculation(element);
    });

  }

  Future<bool> accountExists(String email) async{
    List<Account> accounts = await getAllAccounts();
    List<String> emails = List();
    accounts.forEach((element) {
      emails.add(element.getEmail());
    });

    return emails.contains(email);
  }



  Future<bool> profileExists(String name, String email) async{
    List<Profile> profiles = await getAllProfiles(email);
    List<String> names = List();
    profiles.forEach((element) {
      names.add(element.getName());
    });

    return names.contains(email);
  }

}

