part of awsdart;

class Sign{
  static final algorithm = 'AWS4-HMAC-SHA256';
  var iso = new DateFormat('yyyy-MM-ddTHH:mm:ss');
  
  final String accessKey;
  final String secretKey;
  
  Sign(this.accessKey,this.secretKey);
  
  Request sign2(Request req){
    final query = new Map.from(req.uri.queryParameters);
    query['AWSAccessKeyId'] = accessKey;
    query['SignatureVersion'] = '2';
    query['SignatureMethod'] = 'HmacSHA256';
    query['Timestamp'] = version2date(req.headers['Date']);
    
    final method = req.method;
    final host = req.headers['Host'];
    final path = canonicalPath(req.uri.pathSegments);
    final queryString = canonicalQuery(query);
    final canonical = canonical2(method, host, path, queryString);
    
    final signingKey = UTF8.encode(secretKey);
    final signature = hmac(signingKey, canonical);
    
    query['Signature'] = CryptoUtils.bytesToBase64(signature);
    
    req.uri = new Uri(scheme: req.uri.scheme, userInfo: req.uri.userInfo, 
              host: req.uri.host, port: req.uri.port,
              path: req.uri.path, queryParameters: query);
    return req;
  }
  
  Request sign4(Request req,{String region,
                             String service}){
    final method = req.method;
    final path = canonicalPath(req.uri.pathSegments);
    final query = canonicalQuery(req.uri.queryParameters);
    final headers = canonicalHeaders(req.headers);
    final signed = signedHeaders(req.headers.keys);
    final payloadHash = req.headers['x-amz-content-sha256'];
    final canonical = canonical4(method,path,query,headers,signed,payloadHash);
    
    final date = req.headers['Date'];
    final scope = getScope(date, region, service);
    final credential = credentialScope(scope);
    final canonicalHash = hashHex(canonical);
    final stringToSign = toSign(date, credential, canonicalHash);
    
    final signingKey = getSigningKey(scope);
    final signature = bytesToHex(hmac(signingKey, stringToSign));
    
    var auth = new StringBuffer();
    auth.write('AWS4-HMAC-SHA256 Credential=');
    auth.write(accessKey);
    auth.write('/');
    auth.write(credential);
    auth.write(', SignedHeaders=');
    auth.write(signed);
    auth.write(', Signature=');
    auth.write(signature);
    
    req.headers['Authorization'] = auth.toString();
    return req;
  }

  String hashHex(String data){
    final sha = new SHA256();
    sha.add(UTF8.encode(data));
    return bytesToHex(sha.close());
  }
  
  List<int> hmac(List<int> key, String toSign){
    final hmac = new HMAC(new SHA256(),key);
    hmac.add(UTF8.encode(toSign));
    return hmac.close();
  }
  
  String version2date(String datetime){
    var from = datetime.split('').toList();
    var to = [];
    to.addAll(from.take(4));
    from.removeRange(0, 4);
    to.add('-');
    to.addAll(from.take(2));
    from.removeRange(0, 2);
    to.add('-');
    to.addAll(from.take(5));
    from.removeRange(0, 5);
    to.add(':');
    to.addAll(from.take(2));
    from.removeRange(0, 2);
    to.add(':');
    to.addAll(from.take(2));
    return to.join();
  }
  
  List<int> getSigningKey(List<String> scope){
    return scope.fold(UTF8.encode('AWS4' + secretKey), hmac);
  }

  String toSign(String requestDate, String credentialScope, String canonHash){
    return [algorithm, requestDate, credentialScope, canonHash].join('\n');
  }
  
  List<String> getScope(String date, String region, String service){
    final day = date.substring(0, 8);
    return [day, region, service, 'aws4_request'];
  }
  
  String credentialScope(List<String> scope) => scope.join('/');
  
  String canonical2(String httpRequestMethod,
                    String canonicalHost,
                    String canonicalPath,
                    String canonicalQueryString){
    return [httpRequestMethod,
            canonicalHost,
            canonicalPath,
            canonicalQueryString].join('\n');
  }
  
  String canonical4(String httpRequestMethod,
                    String canonicalPath,
                    String canonicalQueryString,
                    String canonicalHeaders,
                    String signedHeaders,
                    String payloadHash){
    return [httpRequestMethod,
            canonicalPath,
            canonicalQueryString,
            canonicalHeaders,
            signedHeaders,
            payloadHash].join('\n');
  }
  
  String signedHeaders(Iterable<String> keys){
    final sortSet = new SplayTreeSet();
    sortSet.addAll(keys.map((s)=>s.toLowerCase()));
    return sortSet.join(';');
  }
  
  String canonicalHeaders(Map<String,String> headers){
    //Match whitespace that is not inside "".
    //Dont understand this reqexp see:
    //http://stackoverflow.com/questions/6462578/alternative-to-regex-match-all-instances-not-inside-quotes
    final RegExp trimer = new RegExp(r'\s+(?=([^"]*"[^"]*")*[^"]*$)'); 
    final keys = headers.keys.map((s)=>s.toLowerCase()).iterator; 
    final values = headers.values
        .map((s)=>s.trim().replaceAll(trimer,' ')).iterator;
    
    final canon = new SplayTreeMap(); 
    while(keys.moveNext() && values.moveNext()){
      var key = keys.current;
      var value = values.current;
      
      if(canon.containsKey(key)){
        canon[key] += ',' + value;
      }else{
        canon[key] = value;
      }
    }
    
    return canon.keys.map((key) => '$key:${canon[key]}\n').join();
  }
  
  String canonicalPath(List<String> path){
    return '/' + new Uri(pathSegments: path).path;
  }

  String canonicalQuery(Map<String,String> query){
    var keys = query.keys.toList();
    keys.sort(); 
    return keys.map((String key){
      return _awsUriEncode(key) +'='+ _awsUriEncode(query[key]);
    }).join('&');
  }

  String _awsUriEncode(String data){
    var code = Uri.encodeComponent(data);
    code = code.replaceAll('!', '%21');
    code = code.replaceAll('(', '%28');
    code = code.replaceAll(')', '%29');
    code = code.replaceAll('*', '%2A');
    return code;
  }
}