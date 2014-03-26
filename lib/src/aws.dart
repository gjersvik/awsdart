part of awsdart;

/**
 *  The core class of the Amazone Dart library.
 *  
 *  Its jobb is to help send request to Amazone Web Services apis. It takes care
 *  of task that is valid for all amazone requets like:
 *  
 *  * Singing requests with youre secrect key. (TODO)
 *  * Checking checksums where aplicable. (TODO)
 *  * Retrying request wit exponetial backoff. (TODO)
 * 
 */
class Aws{
  /**
   *  Set the default instance of [Aws] that is used by this library.
   *  
   *  If not set manualy its set to the first intance of [Aws] that is created.
   */
  static setDefault(Aws aws) => _default = aws;
  
  /**
   *  Get the deafult instance of [Aws].
   *  
   *  If no inctance is set one is crated by trying to get creaentials from the
   *  enviroment.
   *  
   *  If no creaentials are found it will throw an exseption.
   */
  factory Aws(){
    if(_default != null){
      return _default;
    }
    return new Aws.create();
  }
  
  
  /**
   *  Create a new instance of [Aws].
   *  
   */
  Aws.create({this.accessKey, this.secretKey}){
    if(_default == null){
      _default = this;
    }
    sign = new Sign(accessKey,secretKey);
  }
  
  Sign sign;
  Requester server = new IoRequester();
  
  /// Access key ID that tells AWS how you are.
  String accessKey;
  /// Secret access key proves how you are.
  String secretKey;
  

  static Aws _default;
  
  
  Future<Response> request(Uri uri,{
      String metode: 'GET',
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
    req.metode = metode;
    if(headers != null){
      req.headers.addAll(headers);
    }
    if(body != null){
      req.body = body;
    }
    //TODO auto find region and service.
    req.region = region;
    req.service = service;
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
    req = sign.authenticateRequest(req, signVersion);
    return server.request(req);
  }
}