part of 'servers.dart';

Future<Response> handlerArcticleDetailsRequest(Request request) async {
  var queryParameters = request.url.queryParameters;
  final id = queryParameters['id'];
  if (id == null) {
    return errorResponse(404, 'id not is null');
  }
  var result = await db.queryArticleDetails(int.parse(id));
  if (result == null) {
    return errorResponse(-1, '数据不存在');
  }
  return jsonResponse(result);
}
