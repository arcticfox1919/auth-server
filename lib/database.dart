import 'dart:ffi';

import 'dart:io';

import 'package:sqlite3/sqlite3.dart';
import 'package:sqlite3/open.dart';

import 'user.dart';

DynamicLibrary _openOnWin() {
  final script = File(Platform.script.toFilePath()).parent;
  return DynamicLibrary.open('${script.path}/sqlite3.dll');
}

const _createTable = ''' 
create table if not exists user (
  id integer primary key autoincrement,
  nick_name text,
  user_name text unique,
  passwd text,
  date text
);
''';

class SqliteDb {
  late Database _db;

  SqliteDb.Connect() {
    open.overrideFor(OperatingSystem.windows, _openOnWin);
    _db = sqlite3.open('db/data.db', mutex: false);
    _db.execute(_createTable);
  }

  User save(User user) {
    final insertStmt =
        _db.prepare('insert into user (user_name,passwd,date) values (?,?,?)');
    insertStmt.execute([
      user.uname,
      user.passwd,
      DateTime.now().millisecondsSinceEpoch ~/ 1000
    ]);
    insertStmt.dispose();

    var row =
        _db.select('select id from user where user_name=?', [user.uname]).first;
    user.id = row['id'] as int;
    return user;
  }

  User? getUser(User user) {
    final result = _db.select(
        'select id from user where user_name=? and passwd=?',
        [user.uname, user.passwd]);

    if (result.isEmpty) return null;
    var row = result.first;
    user.id = row['id'] as int;
    return user;
  }

  void close() {
    _db.dispose();
  }
}
