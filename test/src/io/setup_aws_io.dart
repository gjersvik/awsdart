part of awsdart_io_unit;

setupAwsIOTest() => group('setupAwsIO',(){
  test('sets Aws.requester to ioRequester',(){
    // Setup
    Aws.requester = null;
    
    // Action
    setupAwsIO();
    
    // Assertions
    expect(Aws.requester, same(ioRequester));
    
    // Clean up
    Aws.requester = null;
  });
});