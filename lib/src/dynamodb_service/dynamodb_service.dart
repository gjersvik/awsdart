part of awsdart_dynamodb_service;

class DynamodbService{
  static const TARGET = 'DynamoDB_20120810';
  
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
    
    return _request(json, 'GetItem')
      .then((Map json) => new GetItemResult.fromJson(json));
  }
  
  Future<Map> _request(Map json, String target){
    var body = UTF8.encode(JSON.encode(json));
    var headers = {
      'x-amz-target': '$TARGET.$target',
      'Content-Type': 'application/x-amz-json-1.0'
    };
    return _aws.request(_uri, body: body, method:'POST', headers:headers)
        .then((res) => JSON.decode(UTF8.decode(res.body)));
  }
}