part of amazone_dart_unit;

signTest() => group('Sign',(){
  Sign sign;
  
  setUp((){
    sign = new Sign('AKIAIOSFODNN7EXAMPLE',
        'wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY');
  });
  
  tearDown((){
    sign = null;
  });
});