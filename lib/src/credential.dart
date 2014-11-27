part of awsdart;

/// A container for AWS credentials.
///
/// Credential have two properties used by the aws dart library and that is
/// [accessKey] and [secretKey]. If you implement your own version of Credential
/// you can also use getters. The library do not cache the keys and will call
/// you getters for each time it need to sign a request. So that you can
/// implement key rotation.
///
/// You can add createsion to [AwsClinet.credential ] as a default credential
/// for all requests. Or add to an specific [Request.credential] to only use it
/// for that request.
///
/// The library comes with three from methods that will go out and find keys to
/// use from the environment. The all return Futures and may throw an
/// [CredentialNotFoundException].
class Credential{
  /// Returns the example keyset often used by the Aws documentation. And is a
  /// nice null key to use as things like unit test or other code that will
  /// not reach amazon's servers.
  static const exsample = const Credential('AKIAIOSFODNN7EXAMPLE',
      'wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY');
  
  /// Return credentials from the AWS credentials file.
  ///
  /// If [path] is not given it will look at the common places that are
  /// “~/.aws/credentials” on Linux and OS X. Or at
  /// “C:\Users\USERNAME\.aws\credentials”. This is the same place that other
  /// tools and sdk looks for there keys. You can override the default file
  /// location by setting the “AWS_CREDENTIAL_FILE“ environment variable.
  ///
  /// The file format is something like this:
  ///
  ///     [default]
  ///     aws_access_key_id = AKIAIOSFODNN7EXAMPLE
  ///     aws_secret_access_key = wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY
  ///     
  ///     [project1]
  ///     aws_access_key_id = AKIAIOSFODNN7EXAMPLE
  ///     aws_secret_access_key = wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY
  ///
  /// You define what section you want to use with the profile argument.
  ///
  /// The Credential object returned will not update if the file change and if
  /// you need to refresh you need to get a new Credential object by calling
  /// [fromFile] again.
  static Future<Credential> fromFile({String path, String profile: 'default'}){
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

class CredentialNotFoundException implements Exception{

}