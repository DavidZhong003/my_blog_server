import 'package:mysql1/mysql1.dart';

MySqlConnection _connection;

void initDB({String host, int port, String user, String db, String pwd}) async {
  final settings = ConnectionSettings(
      host: host ?? '127.0.0.1',
      port: port ?? 3306,
      user: user,
      db: db,
      password: pwd);

  _connection = await MySqlConnection.connect(settings);
}

Future<Results> queryArticleTitle({int count = 20}) async {
  ///oId articleTitle
  return _connection
      .query('select oId,articleTitle from b3_solo_article limit $count');
}
