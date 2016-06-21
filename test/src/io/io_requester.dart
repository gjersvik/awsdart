part of awsdart_io_unit;

ioRequesterTest() => group('ioRequester', () {
      test('Try and get google.com', () {
        var req = new Request();
        req.method = 'GET';
        req.uri = Uri.parse('https://google.com/');
        expect(
            ioRequester(req).then((res) {
              expect(res.statusCode, 200);
            }),
            completes);
      });
    });
