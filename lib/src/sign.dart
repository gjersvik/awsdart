part of awsdart;

class Sign{
  var iso = new DateFormat('yyyy-MM-ddTHH:mm:ss');
  var long4 = new DateFormat("yyyyMMddTHHmmss'Z'");
  var short4 = new DateFormat('yyyyMMdd');
  
  final String accessKey;
  final List<int> secretKey;
  
  Sign(this.accessKey,String secretKey): secretKey = UTF8.encode(secretKey);
  
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
    auth.write(credentialScope(req));
    auth.write(', SignedHeaders=');
    auth.write(signedHeaders(req.headers));
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
  
  List<String> scope(Request req){
    return [short4.format(req.time), req.region, req.service, 'aws4_request'];
  }
  
  List<int> getKey(Request req, [version = 4]){
    if(version == 4){
      var key = UTF8.encode('AWS4').toList();
      key.addAll(secretKey);
      return scope(req).fold(key, sign);
    }
    return secretKey;
  }
  
  String canonical(Request req, [version = 4]){
    var canon = new StringBuffer();
    // both v2 and v4 start wit metode
    canon.writeln(req.method);
    // v2 need host before path
    if(version == 2){
      canon.writeln(req.headers['host']);
    }
    // CanonicalURI
    canon.writeln(req.uri.path);
    // CanonicalQueryString
    canon.write(canonicalQueryString(req.uri.queryParameters));
    // v2 ends here.
    if(version == 2){
      return canon.toString();
    }
    canon.write('\n');
    
    // CanonicalHeaders
    canon.writeln(canonicalHeaders(req.headers));
    // SignedHeaders
    canon.writeln(signedHeaders(req.headers));
    // PayloadHash
    canon.write(toHex(req.bodyHash));
    
    return canon.toString();
  }
  
  String toSign(Request req, [version = 4]){
    // if verson 2 return canonical.
    if(version == 2){
      return canonical(req, version);
    }
    var canon = new StringBuffer();
    
    // 1. Algorithm
    canon.writeln('AWS4-HMAC-SHA256');
    
    // 2. RequestDate
    canon.writeln(long4.format(req.time));
    
    // 3. CredentialScope
    canon.writeln(credentialScope(req));
    
    // 4. HashedCanonicalRequest
    var hash =  new SHA256();
    hash.add(UTF8.encode(canonical(req, version)));
    canon.write(toHex(hash.close()));
    
    return canon.toString();
  }
  
  String credentialScope(Request req) => scope(req).join('/');
  
  String canonicalQueryString(Map<String,String> query){
    var keys = query.keys.toList();
    keys.sort(); 
    return keys.map((String key){
      return Uri.encodeComponent(key) +'='+ Uri.encodeComponent(query[key]);
    }).join('&');
  }
  
  String canonicalHeaders(Map<String,String> headers){
    var canon = new Map.fromIterables(
        headers.keys.map((s)=>s.toLowerCase()),
        headers.values.map((s)=>s.trim()));
    
    var headersList = canon.keys.toList();
    headersList.sort();
    return headersList.map((key) => '$key:${canon[key]}\n').join();
  }
  
  String signedHeaders(Map<String,String> headers){
    var headersList = headers.keys.map((s)=>s.toLowerCase()).toList();
    headersList.sort();
    return headersList.join(';');
  }
}