part of amazone_dart;

abstract class Requester{
  Future<Response> request(Request req);
}

class Request{
  String metode;
  Uri uri;
  Map<String,String> headers;
  Stream<List<int>> body;
}

class Response{
  int statusCode;
  String statusString;
  Map<String,String> headers;
  Stream<List<int>> body;
}