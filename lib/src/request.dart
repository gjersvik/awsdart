part of amazone_dart;

typedef Responce request(Request req);

class Request{
  String metode;
  String path;
  Map<String,String> headers;
  Stream<List<int>> body;
}

class Responce{
  int statusCode;
  String statusString;
  Map<String,String> headers;
  Stream<List<int>> body;
}