part of awsdart_dynamodb_service;

class GetItemResult{
  ConsumedCapacity consumedCapacity;
  final Map<String,AttributeValue> item = {};
  
  GetItemResult();
  GetItemResult.formJson();
  
  toJson(){
    var data = {};
    if(item.isNotEmpty){
      data['Item'] = item;
    }
  }
}