part of amazone_dart_unit;

signTest() => group('Sign',(){
  test('The exsample from doc to canonical',(){
    var uri = Uri.parse('https://elasticmapreduce.amazonaws.com?' + 
        'Action=DescribeJobFlows&Version=2009-03-31' +
        '&AWSAccessKeyId=AKIAIOSFODNN7EXAMPLE&SignatureVersion=2' +
        '&SignatureMethod=HmacSHA256&Timestamp=2011-10-03T15%3A19%3A30');
    var test = 'GET\n' + 
        'elasticmapreduce.amazonaws.com\n' +
        '/\n' + 
        'AWSAccessKeyId=AKIAIOSFODNN7EXAMPLE&Action=DescribeJobFlows' +
        '&SignatureMethod=HmacSHA256&SignatureVersion=2' +
        '&Timestamp=2011-10-03T15%3A19%3A30&Version=2009-03-31';
    
    expect(new Sign().canonical2('GET', uri), test);
  });
  
  test('The exsample from doc calculateSignature',(){
    var data = 'GET\n' + 
        'elasticmapreduce.amazonaws.com\n' +
        '/\n' + 
        'AWSAccessKeyId=AKIAIOSFODNN7EXAMPLE&Action=DescribeJobFlows' +
        '&SignatureMethod=HmacSHA256&SignatureVersion=2' +
        '&Timestamp=2011-10-03T15%3A19%3A30&Version=2009-03-31';
    var key = 'wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY';
    
    expect(new Sign().calculateSignature2(data, key), 
        'i91nKc4PWAt0JJIdXwz9HxZCJDdiy6cf%2FMj6vPxyYIs%3D');
  });
  
  test('The exsample from doc full signature',(){
    var req = new Request();
    req.metode = 'GET';
    req.uri = Uri.parse('https://elasticmapreduce.amazonaws.com?' + 
        'Action=DescribeJobFlows&Version=2009-03-31');
    var time = new DateTime.utc(2011,10,3,15,19,30);
    
    req = new Sign().sign2(req, 'AKIAIOSFODNN7EXAMPLE',
        'wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY', time);
    
    expect(req.uri.queryParameters['Signature'], 
        'i91nKc4PWAt0JJIdXwz9HxZCJDdiy6cf%2FMj6vPxyYIs%3D');
  });
});