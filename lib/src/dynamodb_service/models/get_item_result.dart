part of awsdart_dynamodb_service;

class GetItemResult{
  final Map<String,AttributeValue> item = {};
  
  GetItemResult();
  GetItemResult.fromJson(Map json){
    Map items = json['Item'];
    var values = items.values.map((m) => new AttributeValue.fromJson(m));
    
    item.addAll(new Map.fromIterables(items.keys, values));
  }
  
  toJson(){
    var data = {};
    if(item.isNotEmpty){
      data['Item'] = item;
    }
    return data;
  }
}