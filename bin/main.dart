import 'package:arowana/arowana.dart';
import 'package:auth_server/server.dart';

void main(List<String> arguments) {
  var app = Application(MyAChannel());
  app.start(numberOfInstances: 2, consoleLogging: true);
}
