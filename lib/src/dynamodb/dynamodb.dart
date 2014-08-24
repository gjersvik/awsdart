part of awsdart_dynamodb;

class Dynamodb {
  DynamodbService _service;

  Dynamodb([DynamodbService service]) {
    if (service != null) {
      _service = service;
    } else {
      _service = new DynamodbService();
    }
  }

  Future<Table> getTable(String name) => new Future.value(new Table._private(
      this, name));
}
