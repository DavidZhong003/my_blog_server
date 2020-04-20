import 'dart:convert';

import 'package:mysql1/mysql1.dart';
import 'package:shelf/shelf.dart';

List<Map<String, dynamic>> _results2String(Results results) =>
    results.toList().map((row) => row.fields).toList();

String encode(Results results) {
  return '{"code":200,"msg":"ok","data":${json.encode(_results2String(results))}}';
}

Response jsonResponse(Results results) =>
    Response.ok(encode(results), headers: {'content-type': 'application/json'});

Response errorResponse(int code,String msg) =>
    Response.ok('{"code":$code,"msg":"$msg"}', headers: {'content-type': 'application/json'});