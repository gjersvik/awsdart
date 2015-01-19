part of awsdart;

class Request {
  String method = 'GET';
  Uri uri = new Uri();
  Map<String,String> headers = {};
  List<int> body = [];
  String region;
  String service;
}