part of amazone_dart;

class Sign{
  var iso = new DateFormat('yyyy-MM-ddTHH:mm:ss');
  var long4 = new DateFormat('yyyyMMddTHH:mm:ssZ');
  var short4 = new DateFormat('yyyyMMdd');
  
  final String accessKey;
  final List<int> secretKey;
  
  Sign(this.accessKey,String secretKey): secretKey = UTF8.encode(secretKey);
  
  Request sign2(Request req, [DateTime time]){
    if(time == null){
      time = new DateTime.now().toUtc();
    }
    var query = new Map.from( req.uri.queryParameters);
    
    query['AWSAccessKeyId'] = accessKey;
    query['SignatureVersion'] = '2';
    query['SignatureMethod'] = 'HmacSHA256';
    query['Timestamp'] = iso.format(time);
    
    var data = canonical2(req.metode,
        new Uri.https(req.uri.authority, req.uri.path, query));
    query['Signature'] = toUrl(sign(secretKey, data));
    
    req.uri = new Uri.https(req.uri.authority, req.uri.path, query);
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
  
  List<int> getKey4(List<String> scope)
      => scope.map(UTF8.encode).fold(secretKey, sign);
  
  String canonical2(String metode, Uri uri){
    var canon = new StringBuffer();
    
    // Start with the request method, followed by a newline character.
    canon.writeln(metode);
    
    // HTTP host header in lowercase, followed by a newline character.
    canon.writeln(uri.authority);
    
    // Add the URL-encoded version of each path segment of the URI
    canon.writeln('/${uri.path}');
    
    //Add the query string components as UTF-8 characters which are URL encoded
    //and sorted using lexicographic byte ordering.
    canon.write(canonicalQueryString(uri.queryParameters));
    
    return canon.toString();
  }
  
  String canonical4(String metode, Uri uri, 
                    Map<String,String> headers, List<int> payloadHash){
    var canon = new StringBuffer();
    
    // 1. HTTPRequestMethod
    canon.writeln(metode);
    // 2. CanonicalURI
    canon.writeln('/${uri.path}');
    // 3. CanonicalQueryString
    canon.writeln(canonicalQueryString(uri.queryParameters)); 
    // 4. CanonicalHeaders
    canon.writeln(canonicalHeaders(headers));
    // 5. SignedHeaders
    canon.writeln(signedHeaders(headers));
    // 6. PayloadHash
    canon.write(toHex(payloadHash));
    
    return canon.toString();
  }
  
  String toSign(DateTime time, String scope, List<int> canonicalHash){
    var canon = new StringBuffer();
    
    // 1. Algorithm
    canon.writeln('AWS4-HMAC-SHA256');
    
    // 2. RequestDate
    canon.writeln(long4.format(time));
    
    // 3. CredentialScope
    canon.writeln(scope);
    
    // 4. HashedCanonicalRequest
    canon.write(toHex(canonicalHash));
    
    return canon.toString();
  }
  
  String credentialScope(DateTime time, String region, String service){
    return [short4.format(time), region, service, 'aws4_request'].join('/');
  }
  
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
    return headersList.map((key) => '$key:${canon[key]}').join('\n');
  }
  
  String signedHeaders(Map<String,String> headers){
    var headersList = headers.keys.map((s)=>s.toLowerCase()).toList();
    headersList.sort();
    return headersList.join(';');
  }
}