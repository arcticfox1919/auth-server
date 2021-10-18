


import 'dart:async';

import 'package:arowana/arowana.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

import 'jwt_util.dart';


class AuthVerifier extends AuthValidator{


  @override
  FutureOr<Authorization?> validate<T>(AuthorizationParser<T> parser, T authorizationData) {
    if (parser is AuthorizationBearerParser) {
      return _verify(authorizationData as String);
    }
    throw ArgumentError(
        "Invalid 'parser' for 'AuthValidator.validate'. Use 'AuthorizationBearerHeader'.");
  }

  FutureOr<Authorization?> _verify(String accessToken) async {
    try {
      final jwt = verifyToken(accessToken);
      return Authorization((jwt.payload as Map)['id'].toString(), this);
    } on JWTUndefinedError catch(e){
      print(e.error);
      if(e.error is JWTExpiredError){
        throw TokenExpiredException('Error: the token has expired, please refresh');
      }
    }
  }
}