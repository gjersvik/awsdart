part of awsdart_dynamodb_service_unit;

attributeValueTest() => group('AttributeValue',(){
  group('setting',(){
    AttributeValue attr;
    setUp(() => attr = new AttributeValue());
    
    test('.b results in type B',(){
      attr.b = [0, 1];
      expect(attr.type, 'B');
    });
    
    test('.bs results in type BS',(){
      attr.bs = [[0, 1], [3, 4]];
      expect(attr.type, 'BS');
    });
    
    test('.s results in type S',(){
      attr.s = 'test string';
      expect(attr.type, 'S');
    });
    
    test('.ss results in type SS',(){
      attr.ss = ['test string', 'another test string'];
      expect(attr.type, 'SS');
    });
    
    test('.n results in type N',(){
      attr.n = 1.2;
      expect(attr.type, 'N');
    });
    
    test('.ns results in type NS',(){
      attr.ns = [1.2, 3];
      expect(attr.type, 'NS');
    });
  });
  
  test('.b return the value if value is of type B',(){
    var attr = new AttributeValue();
    var value = [0, 1];
    
    attr.b = value;
    
    expect(attr.b, value);
  });
  
  test('.b return null if value is not of type B',(){
    var attr = new AttributeValue();
    attr.s = 'test string';
    expect(attr.b, null);
  });
});