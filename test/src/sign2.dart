part of amazone_dart_unit;

sign2Test() => group('Sign2',(){
  test('The exsample from doc',(){
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
    
    expect(new Sign2().canonicalQueryString('GET', uri), test);
  });
});