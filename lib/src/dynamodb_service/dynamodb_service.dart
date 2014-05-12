part of awsdart_dynamodb_service;

class DynamodbService{
  final Aws _aws;
  
  Uri _uri;
  DynamodbService(this._aws, String region){
    _uri = Uri.parse("https://dynamodb.$region.amazonaws.com/");
  }
  
  Future<GetItemResult> getItem(String tableName, Map<String,AttributeValue> keys,{
    List<String> attributesToGet: const [],
    bool consistentRead: false
  }){
    String returnConsumedCapacity = 'NONE';
    Map json = {
      'Key': keys,
      'TableName': tableName
    };
    if(attributesToGet.isNotEmpty){
      json['AttributesToGet'] = attributesToGet;
    }
    if(consistentRead){
      json['ConsistentRead'] = true;
    }
    var body = UTF8.encode(JSON.encode(json));
    
    var headers = {
      'x-amz-target': 'DynamoDB_20120810.GetItem',
      'Content-Type': 'application/x-amz-json-1.0'
    };
    
    return _aws.request(_uri, body: body, method:'POST', headers:headers)
      .then((Response res){
        var json = JSON.decode(UTF8.decode(res.body));
        return new GetItemResult.fromJson(json);
      });
  }
}