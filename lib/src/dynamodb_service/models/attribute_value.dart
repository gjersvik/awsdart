part of awsdart_dynamodb_service;

class AttributeValue{
  
  AttributeValue([dynamic value]);
  AttributeValue.fromJson(Map);
  
  String get type => _type;
  dynamic get value => _value;
  
  List<int> get b => _type == 'B' ? _value : null;
  set b(List<int> blob){
    _type = 'B';
    _value = blob;
  }
  
  Set<List<int>> get bs => _type == 'BS' ? _value : null;
  set bs(Iterable<List<int>> blobSet){
    _type = 'BS';
    _value = blobSet.toSet();
  }
  
  String get s => _type == 'S' ? _value : null;
  set s(String string){
    _type = 'S';
    _value = string;
  }
  
  Set<String> get ss => _type == 'SS' ? _value : null;
  set ss(Iterable<String> stringSet){
    _type = 'SS';
    _value = stringSet.toSet();
  }
  
  num get n => _type == 'N' ? _value : null;
  set n(num number){
    _type = 'S';
    _value = number;
  }
  
  Set<num> get ns => _type == 'NS' ? _value : null;
  set ns(Iterable<num> numberSet){
    _type = 'SS';
    _value = numberSet.toSet();
  }
  
  Map toJson(){
    
  }
  
  String _type;
  var _value;
}