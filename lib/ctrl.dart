import 'package:arowana/arowana.dart';

import 'database.dart';
import 'user.dart';

class RegisterController {
  SqliteDb db;

  RegisterController(this.db);

  Future<Response> call(Request request) async {
    var body = await request.body;
    var json = body.json;
    if (json != null) {
      var user = User.from(json);
      if (user.check()) {
        user.save(db);
        return ResponseX.token(user.generateToken());
      }
    }
    return ResponseX.badRequest('Invalid username or password!');
  }
}

class LoginController {
  SqliteDb db;

  LoginController(this.db);

  Future<Response> call(Request request) async {
    var body = await request.body;
    var json = body.json;
    if (json != null) {
      var user = User.from(json);
      if (user.verify(db)) {
        return ResponseX.token(user.generateToken());
      }
    }
    return ResponseX.badRequest('Invalid username or password!');
  }
}
