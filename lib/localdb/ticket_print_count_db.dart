import 'dart:async';
import 'dart:developer';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../models/ticket_print_count_model.dart';

class TicketPrintCountDb {
  static final TicketPrintCountDb instance = TicketPrintCountDb._init();
  static Database? _database;
  TicketPrintCountDb._init();
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB("localjfill.db");
    return _database!;
  }

  Future<Database> _initDB(String dbName) async {
    log("SQL => INIT DB");
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, dbName);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    log("SQL => Create DB and TABLE");
    const idType = "INTEGER PRIMARY KEY AUTOINCREMENT";
    const boolType = "BOOLEAN NOT NULL";
    const textType = "TEXT NOT NULL";
    const intType = "INTEGER NOT NULL";
    db.execute('''
              CREATE TABLE $ticketPrintCountTable(
              ${TikcetPrintCountFields.id} $idType,
              ${TikcetPrintCountFields.ticketOrderNumber} $textType,
              ${TikcetPrintCountFields.isPrint} $boolType,
              ${TikcetPrintCountFields.printCount} $intType,
              ${TikcetPrintCountFields.lastPrint} $textType
              )
''');
  }

  Future<TicketPrintCountModel> create(
    TicketPrintCountModel ticketPrintCountModel,
  ) async {
    log("SQL => CREATE TABLE RECORDS");
    final db = await instance.database;
    final id = await db.insert(
      ticketPrintCountTable,
      ticketPrintCountModel.toJson(),
    );

    // final json = note.toJson();
    // final columns =
    //     '${NoteFields.title}, ${NoteFields.description}, ${NoteFields.time}';
    // final values =
    //     '${json[NoteFields.title]}, ${json[NoteFields.description]}, ${json[NoteFields.time]}';
    // final id = await db
    //     .rawInsert('INSERT INTO table_name ($columns) VALUES ($values)');
    log("SQL => CREATE TABLE RECORD RESPONSE: ID = " + id.toString());
    return ticketPrintCountModel.copy(id: id);
  }

  Future<TicketPrintCountModel> readTicketPrintCountModel(int id) async {
    final db = await instance.database;
    final maps = await db.query(
      ticketPrintCountTable,
      columns: TikcetPrintCountFields.values,
    );
    if (maps.isNotEmpty) {
      return TicketPrintCountModel.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<List<TicketPrintCountModel>> readAllTicketPrintCountModel() async {
    log("SQL => READ ALL RECORDS IN TABLE");
    final db = await instance.database;
    final result = await db.query(
      ticketPrintCountTable,
    );
    log("SQL => ALL RECORDS FETCH: CNT: " +
        result
            .map((json) => TicketPrintCountModel.fromJson(json))
            .toList()
            .length
            .toString());
    return result.map((json) {
      log("SQL => RECORD ID: " +
          TicketPrintCountModel.fromJson(json).ticketOrderNumber);
      log("SQL => RECORD DATE: " +
          TicketPrintCountModel.fromJson(json).lastPrint.toIso8601String());
      return TicketPrintCountModel.fromJson(json);
    }).toList();
  }

  Future<int> update(TicketPrintCountModel ticketPrintCountModel) async {
    final db = await instance.database;

    return db.update(
      ticketPrintCountTable,
      ticketPrintCountModel.toJson(),
      where: '${TikcetPrintCountFields.id} = ?',
      whereArgs: [ticketPrintCountModel.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await instance.database;

    return await db.delete(
      ticketPrintCountTable,
      where: '${TikcetPrintCountFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
