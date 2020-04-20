import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'db/db_helper.dart' as db;
import 'db/json_help.dart';

Future<Response> handlerArcticleListRequest(Request request) async {
  var queryParameters = request.url.queryParameters;
  final page=queryParameters['page']??'1';
  var result = await db.queryArticleTitle(count: (int.parse(page))*20);
  if (result == null) {
    return Response.ok('');
  }
  return Response.ok(encode(result));
}