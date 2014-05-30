part of awsdart_dynamodb_service;

class DynamodbService{
  static const TARGET = 'DynamoDB_20120810';
  
  Aws _aws;
  
  Uri _uri;
  DynamodbService({Aws aws, String region}){
    if(aws != null){
      _aws = aws;
    }else{
      _aws = new Aws.latest();
    }
    
    if(region == null){
      region = _aws.region;
    }
    
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
  
  Future putItem(String tableName, Map<String,AttributeValue> item){
    String returnConsumedCapacity = 'NONE';
    Map json = {
      'Item': item,
      'TableName': tableName
    };
    
    return _request(json, 'PutItem');
  }
  
  Future deleteItem(String tableName, Map<String,AttributeValue> key){
    String returnConsumedCapacity = 'NONE';
    Map json = {
      'Key': key,
      'TableName': tableName
    };
    
    return _request(json, 'DeleteItem');
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