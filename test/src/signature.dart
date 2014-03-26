part of awsdart_unit;

signatureTest(){
  group('canonicalPath',(){
    test('empty path => /',(){
      expect(canonicalPath([]),'/');
    });
    
    test('[test] => /test',(){
      expect(canonicalPath(['test']),'/test');
    });
    
    test('[root,dir,file.test] => /root/dir/file.test',(){
      expect(canonicalPath(['root','dir','file.test']),'/root/dir/file.test');
    });
    
    test('[wit space] => /wit%20space',(){
      expect(canonicalPath(['wit space']),'/wit%20space');
    });
  });
  
  group('canonicalQuery',(){
    test('{} => empty string',(){
      expect(canonicalQuery({}),'');
    });
    
    test('{a:} => a=',(){
      expect(canonicalQuery({'a':''}),'a=');
    });
    
    test('{a:b,c:,d:e} => a=b&c=&d=e',(){
      expect(canonicalQuery({'a':'b','c':'','d':'e',}),'a=b&c=&d=e');
    });
    
    test('{c:t,b:t,a:t} => a=t&b=t&c=t',(){
      expect(canonicalQuery({'c':'t','b':'t','a':'t',}),'a=t&b=t&c=t');
    });
    
    test('{c:t,B:t,a:t} => B=t&a=t&c=t',(){
      expect(canonicalQuery({'c':'t','B':'t','a':'t',}),'B=t&a=t&c=t');
    });
    
    test('{ABCDEFGHIJKLMNOPQRSTUVWXYZ:} => ABCDEFGHIJKLMNOPQRSTUVWXYZ=',(){
      expect(canonicalQuery({'ABCDEFGHIJKLMNOPQRSTUVWXYZ':'',})
          ,'ABCDEFGHIJKLMNOPQRSTUVWXYZ=');
    });
    
    test('{abcdefghijklmnopqrstuvwxyz:} => abcdefghijklmnopqrstuvwxyz=',(){
      expect(canonicalQuery({'abcdefghijklmnopqrstuvwxyz':'',})
          ,'abcdefghijklmnopqrstuvwxyz=');
    });
    
    test('{0123456789:} => 0123456789=',(){
      expect(canonicalQuery({'0123456789':'',}), '0123456789=');
    });
    
    test('{-_.~:} => -_.~=',(){
      expect(canonicalQuery({'-_.~':'',}), '-_.~=');
    });
    
    test('{space:} => %20=',(){
      expect(canonicalQuery({' ':'',}), '%20=');
    });
    
    test('{!"%&()*+,/;:<=>?@[\]^{|}} => %20=',(){
      expect(canonicalQuery({'!"%&()*+,/;:<=>?@[\]^{|}':'',}),
          '%21%22%25%26%28%29%2A%2B%2C%2F%3B%3A%3C%3D%3E%3F%40%5B%5D%5E%7B%7C%7D=');
    });

    test('{Ø} => %20=',(){
      expect(canonicalQuery({'Ø':'',}),'%C3%98=');
    });
  });
}
