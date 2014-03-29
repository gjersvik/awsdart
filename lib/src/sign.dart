part of awsdart;

class Sign{
  static final algorithm = 'AWS4-HMAC-SHA256';
  var iso = new DateFormat('yyyy-MM-ddTHH:mm:ss');
  var long4 = new DateFormat("yyyyMMddTHHmmss'Z'");
  var short4 = new DateFormat('yyyyMMdd');
  
  final String accessKey;
  final List<int> secretKey;
  
  Sign(this.accessKey,String secretKey): secretKey = UTF8.encode(secretKey);
  
  Request sign2(Request req){
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
    final credential = credentialScope(scope(date, region, service));
    final canonicalHash = hashHex(canonical);
    final stringToSign = toSign(date, credential, canonicalHash);
    return req;
  }

  String hashHex(String data){
    final sha = new SHA256();
    sha.add(UTF8.encode(data));
    return bytesToHex(sha.close());
  }
  
  Request authenticateRequest(Request req, [version = 4]){
    //preperare request.
    req = prepare(req,version);
    
    //get string to sign.
    var string = toSign(req, version);
    
    //get signing key.
    var key = getKey(req, version);
    
    //sign request.
    var hmac = sign(key,string);
    
    //write authentication.
    if(version == 4){
      return writeAuth4(req,hmac);
    }else{
      return writeAuth2(req,hmac);
    }
  }
  
  Request prepare(Request req, [version = 4]){
    if(version == 2){
      //v2 need most of autetication parametes set before signing.
      var query = new Map.from( req.uri.queryParameters);
      query['AWSAccessKeyId'] = accessKey;
      query['SignatureVersion'] = '2';
      query['SignatureMethod'] = 'HmacSHA256';
      query['Timestamp'] = iso.format(req.time);
      req.uri = new Uri(scheme: req.uri.scheme, userInfo: req.uri.userInfo, 
          host: req.uri.host, port: req.uri.port,
          path: req.uri.path, query: req.uri.query);
    }
    
    return req;
  }
  
  Request writeAuth2(Request req, key){
    var query = req.uri.queryParameters;
    query['Signature'] = toUrl(key);
    req.uri = new Uri(scheme: req.uri.scheme, userInfo: req.uri.userInfo, 
              host: req.uri.host, port: req.uri.port,
              path: req.uri.path, query: req.uri.query);
    return req;
  }
  
  Request writeAuth4(Request req, key){
    var auth = new StringBuffer();
    auth.write('AWS4-HMAC-SHA256 Credential=');
    auth.write(accessKey);
    auth.write('/');
    auth.write(credentialScope(scope(req)));
    auth.write(', SignedHeaders=');
    auth.write(signedHeaders(req.headers.keys));
    auth.write(', Signature=');
    auth.write(toHex(key));
    
    req.headers['Authorization'] = auth.toString();
    return req;
  }
  
  sign(List<int> key, String toSign){
    var hmac = new HMAC(new SHA256(),key);
    hmac.add(UTF8.encode(toSign));
    return hmac.close();
  }
  
  String toUrl(List<int> hash) 
      => Uri.encodeComponent(CryptoUtils.bytesToBase64(hash));
  
  String toHex(List<int> hash) 
      => CryptoUtils.bytesToHex(hash);
  
  List<int> getKey(Request req, [version = 4]){
    if(version == 4){
      var key = UTF8.encode('AWS4').toList();
      key.addAll(secretKey);
      return scope(req).fold(key, sign);
    }
    return secretKey;
  }

  String toSign(String requestDate, String credentialScope, String canonHash){
    return [algorithm, requestDate, credentialScope, canonHash].join('\n');
  }
  
  List<String> scope(String date, String region, String service){
    final day = date.substring(0, 8);
    return [day, region, service, 'aws4_request'];
  }
  
  String credentialScope(List<String> scope) => scope.join('/');
  
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