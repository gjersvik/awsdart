part of awsdart;

class Credential{
  /// Returns the example keyset often used by the Aws documentation. And is a
  /// nice null key to use as things like unit test or other code that will
  /// not reach amazon's servers.
  static const exsample = const Credential('AKIAIOSFODNN7EXAMPLE',
      'wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY');
  
  static Future<Credential> fromFile([path]){
    return new Future.microtask(() => throw new UnimplementedError());
  }
  
  static Future<Credential> fromInstance([String roleName]){
    return new Future.microtask(() => throw new UnimplementedError());
  }
  
  static Future<Credential> fromEnvironment([String roleName]){
    return new Future.microtask(() => throw new UnimplementedError());
  }
  
  /// Will try to find the credentials automatically. By trying the from methods in this order:
  /// 1. [fromEnvironment]
  /// 2. [fromFile]
  /// 3. [fromInstance]
  /// If no credential can be found fails the future with a [CredentialNotFound] exception.
  static Future<Credential> auto(){
    return new Future.microtask(() => throw new UnimplementedError());
  }
  
  
  final String accessKey;
  final String secretKey;
  
  const Credential(this.accessKey,this.secretKey);
}

class CredentialNotFound implements Exception{

}