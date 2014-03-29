part of awsdart;

/// Callback for doing the http request over the network.
typedef Future<Response> Requester(Request req);

/// Internal class for repersenting a request out of the library.
class Request{
  String method = 'GET';
  Uri uri = new Uri();
  Map<String,String> headers = {};
  List<int> body = [];
}

/// Internal class for repersenting response from a request out of the library.
class Response{
  int statusCode = 0;
  String statusString = '';
  Map<String,String> headers= {};
  List<int> body = [];
}