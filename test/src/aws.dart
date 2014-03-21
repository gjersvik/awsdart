part of amazone_dart_unit;

awsTest() => group('Aws',(){
  setUp((){
    // make shure defult is not set.
    Aws.setDefault(null);
  });
  
  test('aws returns the same inctane each time.', (){
    expect(new Aws(), new Aws());
  });
});