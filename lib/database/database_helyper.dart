import 'package:flutter/services.dart';
import 'package:books_labry/database/database_model.dart';
import 'package:path/path.dart';
import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
class BooksDataBaseHelper{
  String tablename = "books";
  static final BooksDataBaseHelper instance = BooksDataBaseHelper._instance();
  BooksDataBaseHelper._instance();
  Database _db;
  Future<Database> get db async{
    if(_db == null){
      print("this db is create");
      _db = await initDb();
    }
    return _db;
  }
  Future initDb() async{
    final dbpath = await getDatabasesPath();
    final path = join(dbpath,'books.db');
    final exeist =await databaseExists(path);
    if(exeist){
      print('database is will open');
      await openDatabase(path);
    }else{
      print("creating a copy of database");
      try{
        await Directory(dirname(path)).create(recursive: true);
      }catch(e){
        print(e);
      }
      ByteData data = await rootBundle.load(join("assets","books.db"));
      List<int> bytes =await data.buffer.asInt8List(
          data.offsetInBytes ,data.lengthInBytes
      );
      await File(path).writeAsBytes(bytes,flush: true);
      print('db is coped');
    }
    return await openDatabase(path);
  }
  Future<List<Map<String , dynamic >>> getbooksMapList() async{
    Database db = await this.db;
    final List<Map<String , dynamic >> books_map = await db.query(tablename);
    return books_map;
  }
  Future<List<Model>> getbooksList() async{
    final List<Map<String,dynamic>> map_book = await getbooksMapList();
    final List<Model> books = [];
    map_book.forEach((book) {
      books.add(Model.fromMap(book));
    });
    return books;
  }
  Future<List<Map<String , dynamic >>> getbooksMapListtab(  String tabname ,String tabvalue) async{
    Database db = await this.db;
    final List<Map<String , dynamic >> books_map = await db.query(tablename,where: "$tabname = ? " ,whereArgs: [tabvalue]);
    return books_map;
  }
  Future<List<Model>> getbooksListtab( String tabname , String tabvalue) async{
    final List<Map<String,dynamic>> map_book = await getbooksMapListtab(tabname , tabvalue);
    final List<Model> books = [];
    map_book.forEach((book) {
      books.add(Model.fromMap(book));
    });
    return books;
  }Future<List<Map<String , dynamic >>> getbooksMapListsearch( String search) async{
    Database db = await this.db;
    final List<Map<String , dynamic >> books_map = await db.rawQuery(' SELECT * FROM "$tablename" WHERE "name" LIKE "%$search%" ');
    return books_map;
  }
  Future<List<Model>> getbooksListsearch( String search) async{
    final List<Map<String,dynamic>> map_book = await getbooksMapListsearch(search);
    final List<Model> books = [];
    map_book.forEach((book) {
      books.add(Model.fromMap(book));
    });
    return books;
  }
  Future<int> updatebook(String nametable , String vlaue , int id) async {
    Database db = await this.db;
    // final int result = await db.update(tablename, model.toMap() ,where: 'id = ?' , whereArgs: [model.id]);
    final int result = await db.rawUpdate(' UPDATE books SET "$nametable" =  "$vlaue"   WHERE id = "$id" ');
    return result;
  }
  Future<int> deletebook(int id) async{
    Database db = await this.db;
    final int result = await db.delete(tablename , where: "id = ?" , whereArgs: [id]);
    return result;
  }
  Future<int> updatefav(String nametable , String vlaue , int id) async {
    Database db = await this.db;
    // final int result = await db.update(tablename, model.toMap() ,where: 'id = ?' , whereArgs: [model.id]);
    final int result = await db.rawUpdate(" UPDATE books SET $nametable =  $vlaue   WHERE id = $id ");
    return result;
  }
  Future<int> updateisdown(String nametable , String vlaue , int id) async {
    Database db = await this.db;
    // final int result = await db.update(tablename, model.toMap() ,where: 'id = ?' , whereArgs: [model.id]);
    final int result = await db.rawUpdate(" UPDATE books SET $nametable =  $vlaue   WHERE id = $id ");
    return result;
  }
  Future<int> updateispage(String nametable , String vlaue , int id) async {
    Database db = await this.db;
    // final int result = await db.update(tablename, model.toMap() ,where: 'id = ?' , whereArgs: [model.id]);
    final int result = await db.rawUpdate(" UPDATE books SET $nametable =  $vlaue   WHERE id = $id ");
    return result;
  }

}