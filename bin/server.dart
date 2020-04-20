import 'dart:io';

import 'package:args/args.dart';
import 'package:shelf/shelf.dart' as shelf;
import 'package:shelf/shelf_io.dart' as io;
import 'arcticle_list.dart';
import 'db/db_helper.dart' as db;
import 'db/json_help.dart';
// For Google Cloud Run, set _hostname to '0.0.0.0'.
const _hostname = 'localhost';

void main(List<String> args) async {
  // Open a connection (testdb should already exist)
  var parser = ArgParser()
    ..addOption('port', abbr: 'p')
    ..addOption('db_user')
    ..addOption('db_pwd')
    ..addOption('db_port')
    ..addOption('db_name')
    ..addOption('db_host');
  var result = parser.parse(args);
  // For Google Cloud Run, we respect the PORT environment variable
  var portStr = result['port'] ?? Platform.environment['PORT'] ?? '8080';
  var port = int.tryParse(portStr);
  if (port == null) {
    stdout.writeln('Could not parse port value "$portStr" into a number.');
    exitCode = 64;
    return;
  }
  // init DB
  db.initDB(
      host: result['db_host'],
      user: result['db_user'],
      pwd: result['db_pwd'],
      db: result['db_name'],
      port: int.tryParse(result['db_port']));

  var handler = const shelf.Pipeline()
      .addMiddleware(shelf.logRequests())
      .addHandler((request) async {
    final path = request.url.path;
    print('path:$path');
    var handler = _handlerMap[path];
    if (handler != null) {
      return handler(request);
    }
    return errorResponse(404, '$path not found');
  });

  var server = await io.serve(handler, _hostname, port);
  print('Serving at http://${server.address.host}:${server.port}');
}

Map<String, shelf.Handler> _handlerMap = {
  'arcticleList': handlerArcticleListRequest
};
