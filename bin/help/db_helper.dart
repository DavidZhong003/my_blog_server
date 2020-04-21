import 'package:mysql1/mysql1.dart';

MySqlConnection _connection;

///初始化数据库
void initDB({String host, int port, String user, String db, String pwd}) async {
  final settings = ConnectionSettings(
      host: host ?? '127.0.0.1',
      port: port ?? 3306,
      user: user,
      db: db,
      password: pwd);

  _connection = await MySqlConnection.connect(settings);
}

/// 查询
Future<Results> _query({
  String tabName = 'b3_solo_article',
  List<String> column,
  String where,
  String order,
  int limitStart = 0,
  int count,
}) async {
  var columns = (column == null) ? '*' : column.join(',');
  var w = where == null ? '' : 'where $where';
  var o = order == null ? '' : 'order by $order';
  var l = (count == null) ? '' : 'limit $limitStart , $count';
  var sql = 'select $columns from $tabName $w $o $l';
  print(sql);
  return _connection.query(sql);
}

/// 查看文章列表
Future<Results> queryArticleTitle({int count = 20}) async {
  return _query(
      column: ['oId', 'articleTitle', 'articleImg1URL', 'articleUpdated'],
      order: 'articleUpdated',
      count: count);
}

/// 详情
Future<Results> queryArticleDetails(int oId) async {
  return _query(column: [
    'oId',
    'articleTitle',
    'articleImg1URL',
    'articleUpdated',
    'articleContent',
  ], where: 'oId=$oId');
}
