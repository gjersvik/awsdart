part of awsdart_dynamodb_service;

class AttributeValue{
  
  AttributeValue();
  AttributeValue.fromJson(Map json){
    String type = json.keys.first;
    var value = json.values.first;
    switch (type){
      case 'B':
        b = CryptoUtils.base64StringToBytes(value);
        break;
      case 'BS':
        bs = value.map(CryptoUtils.base64StringToBytes);
        break;
      case 'S':
        s = value;
        break;
      case 'SS':
        ss = value;
        break;
      case 'N':
        n = num.parse(value);
        break;
      case 'NS':
        ns = _value.map(num.parse);
        break;
    }
  }
  
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
    _type = 'N';
    _value = number;
  }
  
  Set<num> get ns => _type == 'NS' ? _value : null;
  set ns(Iterable<num> numberSet){
    _type = 'NS';
    _value = numberSet.toSet();
  }
  
  Map toJson(){
    switch (_type){
      case 'B':
        return {_type: CryptoUtils.bytesToBase64(_value)};
      case 'BS':
        return {_type: _value.map(CryptoUtils.bytesToBase64).toList()};
      case 'S':
        return {_type: _value};
      case 'SS':
        return {_type: _value.toList()};
      case 'N':
        return {_type: _value.toString()};
      case 'NS':
        return {_type: _value.map((n) => n.toString()).toList()};
      default:
        return {};
    }
  }
  
  String _type;
  var _value;
  
  toString() => 'AttributeValue($type:$value)';
}