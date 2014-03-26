part of awsdart_unit;

awsTest() => group('Aws',(){
  setUp((){
    // make shure defult is not set.
    Aws.setDefault(null);
  });
  
  test('aws returns the same inctane each time.', (){
    new Aws.create(accessKey: 'AKIAIOSFODNN7EXAMPLE',
        secretKey: 'wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY');
    expect(new Aws(), new Aws());
  });
});