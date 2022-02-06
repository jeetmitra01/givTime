import 'dart:io';
import 'Ngo.dart';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DbHelper {

  DbHelper._();
  static final DbHelper db = DbHelper._();

  static Database _database;
  Future<Database> get database async {
      // if (_database != null) 
      // return _database; 
      _database = await initDb(); 
      return _database; 
   }
  Future initDb() async{

    final dbPath = await getDatabasesPath();
    final path = join(dbPath, "NGO.db");

    // final exist = await databaseExists(path);

    // if(exist){

    // }
    // else{
      try{
        await Directory(dirname(path)).create(recursive: true);

      }
      catch(_){}

      ByteData data = await rootBundle.load(join("assets", "NGO.db"));
      List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      await File(path).writeAsBytes(bytes, flush: true);
    //}
    return await openDatabase(path);
  }
  Future<List<Ngo>> getAllNgo() async {
    final db = await database; 
    List<Map> results = await db.query(
      "NGOsNoida", columns: Ngo.columns, orderBy: "id ASC"
    ); 

    List<Ngo> ngos = new List();   

    results.forEach((result) {
        Ngo ngo = Ngo.fromMap(result); 
        ngos.add(ngo); 
    }); 

    return ngos; 
  } 
}