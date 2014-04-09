library awsdart_io;

import 'dart:async';
import 'dart:io';

import 'package:awsdart/core.dart';
export 'package:awsdart/core.dart';

setupAwsIO(){
  Aws.requester = ioRequester;
}

Future<Response> ioRequester(Request req) {
  var _client =  new HttpClient();
  return _client.openUrl(req.method, req.uri)
      .then((HttpClientRequest request){
        req.headers.forEach(request.headers.add);
        request.add(req.body);
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
