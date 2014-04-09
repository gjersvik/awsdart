part of awsdart_core;

class Credential{
  final String accessKey;
  final String secretKey;
  final String token;
  final DateTime expire;
  const Credential(this.accessKey, this.secretKey): token = null, expire = null;
  const Credential.full(this.accessKey,this.secretKey,this.token, this.expire);
  
  Future<Credential> getCretential() => new Future.value(this);
}