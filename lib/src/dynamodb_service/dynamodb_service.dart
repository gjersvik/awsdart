part of awsdart_dynamodb_service;

class DynamodbService{
  final Aws _aws;
  DynamodbService(this._aws);
  
  Future<GetItemResult> getItem(String tableName, Map<String,AttributeValue> keys,{
    List<String> attributesToGet: const [],
    bool consistentRead: false,
    String returnConsumedCapacity: 'NONE'
  }){
    return new Future(()=> throw new UnimplementedError());
  }
}