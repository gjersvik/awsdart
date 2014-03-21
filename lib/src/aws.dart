part of amazone_dart;

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
  static Aws _default;
  
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
  Aws.create(){
    if(_default == null){
      _default = this;
    }
  }
}