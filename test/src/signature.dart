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

}