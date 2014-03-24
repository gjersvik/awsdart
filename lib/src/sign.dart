part of amazone_dart;

class Sign{
  var iso = new DateFormat('yyyy-MM-ddTHH:mm:ss');
  
  Request sign2(Request req, String accessKey,
               String secretKey, [DateTime time]){
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
    query['Signature'] = calculateSignature2(data, secretKey);
    
    req.uri = new Uri.https(req.uri.authority, req.uri.path, query);
    return req;
  }
  
  String canonical2(String metode, Uri uri){
    var canon = new StringBuffer();
    
    // Start with the request method, followed by a newline character.
    canon.writeln(metode);
    
    // HTTP host header in lowercase, followed by a newline character.
    canon.writeln(uri.authority);
    
    // Add the URL-encoded version of each path segment of the URI
    var path = uri.pathSegments.map(Uri.encodeComponent).join('/');
    canon.writeln('/$path');
    
    //Add the query string components as UTF-8 characters which are URL encoded
    //and sorted using lexicographic byte ordering.
    var query = uri.queryParameters;
    var keys = query.keys.toList();
    keys.sort(); 
    canon.write(keys.map((String key){
      return Uri.encodeComponent(key) +'='+ Uri.encodeComponent(query[key]);
    }).join('&'));
    
    return canon.toString();
  }
  
  String calculateSignature2(String canonical, String secretKey){
    var hmac = new HMAC(new SHA256(),UTF8.encode(secretKey));
    hmac.add(UTF8.encode(canonical));
    return Uri.encodeComponent(CryptoUtils.bytesToBase64(hmac.close()));
  }
}