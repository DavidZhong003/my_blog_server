import 'dart:convert';

import 'package:mysql1/mysql1.dart';


List<Map<String,dynamic>> _results2String(Results results)
  => results.toList().map((row)=>row.fields).toList();


String encode(Results results){
  return '{"code":"200","msg":"ok","data":${json.encode(_results2String(results))}}';
}

