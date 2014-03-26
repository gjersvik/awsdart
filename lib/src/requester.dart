part of awsdart;

abstract class Requester{
  Future<Response> request(Request req);
}

class Request{
  String method = 'GET';
  Uri uri;
  Map<String,String> headers = {};
  List<int> body = [];
  List<int> bodyHash;
  String region;
  String service;
  DateTime time = new DateTime.now().toUtc();
}

class Response{
  int statusCode;
  String statusString;
  Map<String,String> headers;
  List<int> body;
}