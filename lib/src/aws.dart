part of awsdart;

/**
 *  The core class of the Amazone Dart library.
 *  
 *  Its jobb is to help send request to Amazone Web Services apis. It takes care
 *  of task that is valid for all amazone requets like:
 *  
 *  * Singing requests with youre secrect key.
 * 
 */
class Aws{
  static final _logger = LoggerFactory.getLoggerFor(Aws);
  
  Sign _sign;
  Requester _server = new IoRequester();
  
  /// Access key ID that tells AWS how you are.
  String accessKey;
  /// Secret access key proves how you are.
  String secretKey;
  
  /**
   *  Create a new instance of [Aws].
   *  
   */
  Aws({this.accessKey, this.secretKey}){
    _sign = new Sign(accessKey,secretKey);
  }
  
  /**
   * Request a Amazone Web Service like request.
   * 
   * Makes a request based on your uri.
   * 
   * Before it is sent its signed wit your [accessKey] and [secretKey].
   * 
   * The important optional parameters are [method],[headers],[body] and 
   * [signVersion]. The last [signVersion] you decide if the request is to be
   * signed wit version 2 or 4 of aws signature algorithm.
   * 
   * [region],[service] and [time] let you override some of the signing
   * parameters. And should not be needed to change in normal circumstances.
   */
  Future<Response> request(Uri uri,{
      String method: 'GET',
      Map<String,String> headers,
      List<int> body,
      String region,
      String service,
      DateTime time,
      int signVersion: 4
    }){
    
    //Creates a request object.
    var req = new Request();
    req.uri = uri;
    req.method = method;
    if(headers != null){
      req.headers.addAll(headers);
    }
    if(body != null){
      req.body = body;
    }
    if(region != null){
      req.region = region;
    }else{
      req.region = hostnameToRegion(req.uri.host);
    }
    if(service != null){
      req.service = service;
    }else{
      req.service = hostnameToService(req.uri.host);
    }
    
    if(time != null){
      req.time =  time.toUtc();
    }
    
    //set Host header if not set.
    req.headers.putIfAbsent('Host', () => req.uri.host);
    //set Date header if not set.
    req.headers.putIfAbsent('Date',
        () => new DateFormat("yyyyMMddTHHmmss'Z'").format(req.time));
    
    //Calculate hash of body.
    //Use x-amz-content-sha256 header if set.
    if(req.headers.containsKey('x-amz-content-sha256')){
      req.hashCode = hexToBytes(req.headers['x-amz-content-sha256']);
    }else{
      req.bodyHash = (new SHA256()..add(req.body)).close();
      req.headers['x-amz-content-sha256'] = bytesToHex(req.bodyHash);
    }
    
    //Sign the request.
    if(signVersion == 4){
      req = _sign.sign4(req, service: req.service, region: req.region);
    }else{
      req = _sign.sign2(req);
    }
    
    return _server.request(req).then((res){
      //logging
      var log = '${req.uri} ${res.statusCode} ${res.statusString}';
      if(res.statusCode < 400){
        _logger.info(log);
      }else{
        _logger.warn(log);
      }
      
      //debug log;
      if(_logger.debugEnabled){
        // req headers'
        var headers = 'Request Headers: \n';
        req.headers.forEach((k,v)=> headers += '$k: $v\n');
        _logger.debug(headers);
        // responce headers.
        headers = 'Responce Headers: \n';
        res.headers.forEach((k,v)=> headers += '$k: $v\n');
        _logger.debug(headers);
        
        if(res.statusCode >= 400){
          _logger.debug(UTF8.decode(res.body));
        }
        
        if(res.statusCode == 403){
          //_logger.debug('Canonical request: \n${_sign.canonical(req, signVersion)}');
          if(signVersion == 4){
            //_logger.debug('String to sign: \n${_sign.toSign(req, 4)}');
          }
        }
      }
      
      return res;
    });
  }
}