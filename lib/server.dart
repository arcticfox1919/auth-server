import 'package:arowana/arowana.dart';
import 'package:server/database.dart';
import 'package:server/verifier.dart';

import 'ctrl.dart';

class MyAChannel extends DefaultChannel{

  late SqliteDb db;

  @override
  Future prepare() async{
    db = SqliteDb.Connect();
  }

  @override
  void entryPoint() {
    post('/register', RegisterController(db));
    post('/login', LoginController(db));

    var r = group('/info');
    r.use(Auth.bearer(AuthVerifier()));

    r.get('/list', (request){
      return ResponseX.ok({
        'language': [
          {'id': 1, 'name': 'dart'},
          {'id': 2, 'name': 'java'},
          {'id': 3, 'name': 'c'},
          {'id': 4, 'name': 'golang'},
          {'id': 5, 'name': 'python'}
        ]
      });
    });
  }
}

