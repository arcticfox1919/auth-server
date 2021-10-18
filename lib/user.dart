import 'dart:convert';

import 'package:arowana/arowana.dart';
import 'package:crypto/crypto.dart';
import 'package:server/database.dart';
import 'package:server/jwt_util.dart';

class User {
  int? id;
  String? uname;
  String? passwd;

  User.from(Map<String, dynamic> json) {
    uname = json['uname'];
    passwd = json['passwd'];
  }

  bool verify(SqliteDb db) {
    if (!check()) return false;
    passwd = md5.convert(utf8.encode(passwd!)).toString();
    var u = db.getUser(this);
    if(u == null) return false;
    id = u.id;
    return true;
  }



  void save(SqliteDb db){
    if(check()){
      // hash passwd
      passwd = md5.convert(utf8.encode(passwd!)).toString();
      var u = db.save(this);
      id = u.id;
    }
  }

  bool check() =>
      uname != null &&
      uname!.isNotEmpty &&
      passwd != null &&
      passwd!.isNotEmpty;

  AuthToken generateToken({Duration expiration = const Duration(hours: 24)}) {
    var now = DateTime.now();
    var expirationDate = now.add(expiration);
    var t = createToken(
        this, expirationDate.millisecondsSinceEpoch~/1000);
    return AuthToken(t, now, expirationDate);
  }
}
