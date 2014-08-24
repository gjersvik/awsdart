part of awsdart_dynamodb;

class Item {
  Map<String, AttributeValue> _data;

  operator [](String name) {
    if (_data.containsKey(name)) {
      return _data[name].value;
    } else {
      return null;
    }
  }

  Map toMap() => new Map.fromIterables(_data.keys, _data.values.map((attr) =>
      attr.value));

  Item._(this._data);
}
