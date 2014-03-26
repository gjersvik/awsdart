part of awsdart_unit;

ioRequesterTest() => group('IoRequester',(){
  test('Try and get google.com',(){
    var io = new IoRequester();
    var req = new Request();
    req.method = 'GET';
    req.uri = Uri.parse('https://google.com/');
    expect(io.request(req).then((res){
      expect(res.statusCode, 200);
    }), completes);
  });
});