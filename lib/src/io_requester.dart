part of awsdart;

class IoRequester extends Requester{
  HttpClient _client =  new HttpClient();

  @override
  Future<Response> request(Request req) {
    return _client.openUrl(req.metode, req.uri)
        .then((HttpClientRequest request){
          if(req.headers != null){
            req.headers.forEach(request.headers.add);
          }
          if(req.body != null){
            request.add(req.body);
          }
          return request.close();
        })
        .then((HttpClientResponse response){
          var res = new Response();
          res.statusCode =  response.statusCode;
          res.statusString = response.reasonPhrase;
          var headers = {};
          response.headers.forEach((name,list){
            headers[name] = list.join(',');
          });
          res.headers = headers;
          return response.fold([], (List body,next)=> body..addAll(next))
            .then((data) => res..body = data);
        });
  }
}