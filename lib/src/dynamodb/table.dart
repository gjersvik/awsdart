part of awsdart_dynamodb;

class Table {
  final String name;

  final Dynamodb _dynamodb;

  Future<Item> get(key, [rangekey]) {
    return new Future.value(new Item._({}));
  }

  Table._private(this._dynamodb, this.name);
}
