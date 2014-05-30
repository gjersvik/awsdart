part of awsdart_dynamodb;

class Dynamodb {
  DynamodbService  _service;
  
  Dynamodb(DynamodbService service){
    if(service != null){
      _service = service;
    }
  }
  
}