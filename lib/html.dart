library awsdart_html;

import 'dart:async';
import 'dart:html';
import 'dart:convert';
import 'dart:typed_data';

import 'package:awsdart/core.dart';
export 'package:awsdart/core.dart';

setupAwsHtml(){
  Aws.requester = htmlRequester;
}

Future<Response> htmlRequester(Request req) {
  return HttpRequest.request(req.uri.toString(), method: req.method,
      requestHeaders: req.headers, sendData: req.body)
      .then((HttpRequest response){
        var res = new Response();
        res.statusCode =  response.status;
        res.statusString = response.statusText;
        res.headers = response.responseHeaders;
        var data = response.response;
        if(data is Document){
          data = data.toString();
        }
        if(data is String){
          data = UTF8.encode(data);
        }else if(data is Blob){
          throw 'Dont know how to do Blob yet.';
        }else if(data is ByteBuffer){
          data = new Uint8List.view(data).toList();
        }else{
          data = [];
        }
        res.body = data;
        return res;
      });
}
