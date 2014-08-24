part of awsdart_dynamodb;

class Table{
  Future<Item> get(key, [rangekey]){
    return new Future.value(new Item());
  }
}