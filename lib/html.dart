library awsdart_html;

import 'dart:async';
import 'dart:html';
import 'dart:typed_data';

import 'package:awsdart/core.dart';
export 'package:awsdart/core.dart';

setupAwsHtml(){
  Aws.requester = htmlRequester;
}

Future<Response> htmlRequester(Request req) {
  var sendData = req.body;
  if(req.method == 'GET' || req.body.isEmpty){
    sendData = null;
  } else {
    var data = new Uint8List.fromList(req.body);
    sendData = data.buffer;
  }
  
  return HttpRequest.request(req.uri.toString(), method: req.method,
      requestHeaders: req.headers, sendData: sendData,
      responseType:'arraybuffer')
      .then((HttpRequest response){
        var res = new Response();
        res.statusCode =  response.status;
        res.statusString = response.statusText;
        res.headers = response.responseHeaders;
        var data = response.response;
        if(data is ByteBuffer){
          data = new Uint8List.view(data).toList();
        }else{
          data = [];
        }
        res.body = data;
        return res;
      });
}
