part of awsdart_dynamodb_service;

class ConsumedCapacity{
  double capacityUnits;
  Map<String,Capacity> globalSecondaryIndexes;
  Map<String,Capacity> localSecondaryIndexes;
  Capacity table;
  String tableName;
}