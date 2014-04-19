part of awsdart_dynamodb_service;

class AttributeValue{
  
  AttributeValue([dynamic value]);
  AttributeValue.fromJson(Map);
  
  var value;
  
  List<int> b;
  Set<List<int>> bs;
  String s;
  Set<String> ss;
  num n;
  Set<num> ns;
  
  Map toJson(){
    
  }
  
  String _type;
  var _value;
}