part of awsdart_dynamodb_service;

class Capacity{
  double capacityUnits = 0.0;
  
  Capacity();
  Capacity.fromJson(Map json){
    if(json.containsKey('CapacityUnits')){
      capacityUnits = json['CapacityUnits'].toDouble();
    }
  }
  
  toJson(){
    if(capacityUnits != 0.0){
      return {'CapacityUnits': capacityUnits};
    }else{
      return {};
    }
  }
}