import 'dart:convert';

import 'package:mysql1/mysql1.dart';
import 'package:shelf/shelf.dart';
import 'package:date_format/date_format.dart';

typedef Converter<T, R> = R Function(T field);
typedef EntryConverter<K, V> = MapEntry<K, V> Function(K key, V value);

/// json响应
Response jsonResponse(Results results,
    {Converter<Map<String, dynamic>, Map<String, dynamic>> rowsConverter,
    EntryConverter<String, dynamic> entryConverter}) {
  var rows = results.toList().map((row) {
    var fields = row.fields;
    if (rowsConverter != null) {
      fields = rowsConverter(fields);
    }

    /// 数据处理
    fields = fields.map(((key, value) {
      /// 处理 binary large object 数据
      if (value is Blob) {
        return MapEntry(key, value.toString());
      }
      return MapEntry(key, value);
    }));
    if (entryConverter != null) {
      fields = fields.map(entryConverter);
    }
    return fields;
  }).toList();

  final data = jsonEncode(rows.length == 1 ? rows.first : rows);
  var json = '{"code":200,"msg":"ok","data":${data ?? ''}}';
  return Response.ok(json, headers: {'content-type': 'application/json'});
}

/// 错误响应
Response errorResponse(int code, String msg) =>
    Response.ok('{"code":$code,"msg":"$msg"}',
        headers: {'content-type': 'application/json'});

/// 毫秒转为String
/// [yyyy-mm-dd HH:mm:ss]
String date2String(int mill) => formatDate(
    DateTime.fromMillisecondsSinceEpoch(mill),
    [yyyy, '-', mm, '-', dd, ' ', HH, ':', mm, ':', ss]);
