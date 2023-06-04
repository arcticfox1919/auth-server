import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

import 'user.dart';

final _secretKey = SecretKey('www.bczl.xyz');

String createToken(User u, int seconds) {
  final jwt = JWT(
    {'id': u.id, 'username': u.uname, 'exp': seconds},
    issuer: 'www.bczl.xyz',
  );

  // Sign it (default with HS256 algorithm)
  return jwt.sign(_secretKey);
}

JWT verifyToken(String token) {
  return JWT.verify(token, _secretKey);
}
