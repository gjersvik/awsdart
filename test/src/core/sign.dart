part of awsdart_core_unit;

signTest() => group('Sign',(){
  // Factoris
  Sign withVersion2Keys() => new Sign('AKIAIOSFODNN7EXAMPLE', 
      'wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY');
  Sign withVersion4Keys() => new Sign('AKIAIOSFODNN7EXAMPLE', 
      'wJalrXUtnFEMI/K7MDENG+bPxRfiCYEXAMPLEKEY');
  Sign withoutKeys() => new Sign('nokey','nokey');
  
  test('sign2 from exsaple from doc.', (){
    final sign = withVersion2Keys();
    final req = new Request();
    req.method = 'GET';
    req.uri = Uri.parse('https://elasticmapreduce.amazonaws.com?Action=DescribeJobFlows&Version=2009-03-31');
    req.headers['Host'] = 'elasticmapreduce.amazonaws.com';
    req.headers['Date'] = '20111003T151930Z';
    
    final future = sign.sign2(req);
    
    expect(future.then((request){
      expect(request.uri.queryParameters['AWSAccessKeyId'], 'AKIAIOSFODNN7EXAMPLE');
      expect(request.uri.queryParameters['SignatureVersion'], '2');
      expect(request.uri.queryParameters['SignatureMethod'], 'HmacSHA256');
      expect(request.uri.queryParameters['Timestamp'], '2011-10-03T15:19:30');
      expect(request.uri.queryParameters['Signature'], 'i91nKc4PWAt0JJIdXwz9HxZCJDdiy6cf/Mj6vPxyYIs=');
    }), completes);
  });
  
  test('hashHex abc => ba7816bf8f01cfea414140de5dae2223b00361a396177a9cb410ff61f20015ad',(){
    final sign = withoutKeys();
    
    final out = sign.hashHex('abc');
    
    expect(out, 'ba7816bf8f01cfea414140de5dae2223b00361a396177a9cb410ff61f20015ad');
  });
  
  test('version2date 20130607T080910Z = 2013-06-07T08:09:10',(){
    final sign = withoutKeys();
    
    final out = sign.version2date('20130607T080910Z');
    
    expect(out, '2013-06-07T08:09:10');
  });
  
  test('getSigningKey',(){
    final sign = withVersion4Keys();
    final scope = ['20110909', 'us-east-1', 'iam', 'aws4_request'];
    final signingKey = [152, 241, 216, 137, 254, 196, 244,  66,
                         26, 220,  82,  43, 171,  12, 225, 248,
                         46, 105,  41, 194,  98, 237,  21, 229,
                        169,  76, 144, 239, 209, 227, 176, 231];
    
    final out = sign.getSigningKey(scope);
    
    expect(out, signingKey);
  });
  
  test('toSign a b c => AWS4-HMAC-SHA256\\na\\nb\\nc',(){
    final sign = withoutKeys();
    
    final out = sign.toSign('a', 'b', 'c');
    
    expect(out, 'AWS4-HMAC-SHA256\na\nb\nc');
  });
    
  test('getScope 20000101T000000Z b c => 20000101 b c aws4_request',(){
    final sign = withoutKeys();
    
    final out = sign.getScope('20000101T000000Z', 'b', 'c');
    
    expect(out, ['20000101', 'b', 'c', 'aws4_request']);
  });
  
  test('canonical4 a b c d e f => a\\nb\\nc\\nd\\ne\\nf',(){
    final sign = withoutKeys();
    
    final out = sign.canonical4('a', 'b', 'c', 'd', 'e', 'f');
    
    expect(out, 'a\nb\nc\nd\ne\nf');
  });
  
  group('signedHeaders',(){
    final testData = {
      []: '',
      ['A']: 'a',
      ['d', 'c', 'b', 'a']: 'a;b;c;d',
      ['abc', 'aBc', 'ABC']: 'abc'
    };
    
    // Create Test Suite;
    testData.forEach((input, output){
      test('$input => $output', (){
        final sign = withoutKeys();
        
        final out = sign.signedHeaders(input);
        
        expect(out, output);
      });
    });
  });
  
  group('canonicalHeaders',(){
    final testData = {
      {}: '',
      {'':''}: ':\n',
      {'a':''}: 'a:\n',
      {'a':'b','c':'','d':'e',}: 'a:b\nc:\nd:e\n',
      {'c':'t','b':'t','a':'t',}: 'a:t\nb:t\nc:t\n',
      {'ABC':'t'}: 'abc:t\n',
      {'C':'t','b':'t','a':'t',}: 'a:t\nb:t\nc:t\n',
      {'a':'  t  t  '}: 'a:t t\n',
      {'a':'  "t  t"  '}: 'a:"t  t"\n',
      {'abc':'a', 'aBc':'b','ABC':'c'}: 'abc:a,b,c\n' 
    };
    
    //Create Test Suite;
    testData.forEach((input, String output){
      // dont want to print the actual new lines in test name.
      test('$input => ${output.replaceAll('\n',r'\n')}', (){
        final sign = withoutKeys();
        
        final out = sign.canonicalHeaders(input);
        
        expect(out, output);
      });
    });
  });
  
  group('canonicalPath',(){
    final testData = {
      []: '/',
      ['test']: '/test',
      ['root','dir','file.test']: '/root/dir/file.test',
      ['wit space']: '/wit%20space'
    };
    
    // Create Test Suite;
    testData.forEach((input, output){
      test('$input => $output', (){
        final sign = withoutKeys();
        
        final out = sign.canonicalPath(input);
        
        expect(out, output);
      });
    });
  });
  
  group('canonicalQuery',(){
    final testData = {
      {}: '',
      {'a':''}: 'a=',
      {'a':'b','c':'','d':'e'}: 'a=b&c=&d=e',
      {'c':'t','b':'t','a':'t'}: 'a=t&b=t&c=t',
      {'C':'t','b':'t','a':'t'}: 'C=t&a=t&b=t',
      {'ABCDEFGHIJKLMNOPQRSTUVWXYZ':''}: 'ABCDEFGHIJKLMNOPQRSTUVWXYZ=',
      {'abcdefghijklmnopqrstuvwxyz':'',}: 'abcdefghijklmnopqrstuvwxyz=',
      {'0123456789':'',}: '0123456789=',
      {'-_.~':'',}: '-_.~=',
      {' ':'',}: '%20=',
      {'!"%&()*+,/;:<=>?@[\]^{|}':'',}:
        '%21%22%25%26%28%29%2A%2B%2C%2F%3B%3A%3C%3D%3E%3F%40%5B%5D%5E%7B%7C%7D=',
      {'Ø':'',}: '%C3%98='
    };
    
    // Create Test Suite;
    testData.forEach((input, output){
      test('$input => $output', (){
        final sign = withoutKeys();
        
        final out = sign.canonicalQuery(input);
        
        expect(out, output);
      });
    });
  });
});