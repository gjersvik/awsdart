part of awsdart_core_unit;

signTest() => group('Sign', () {
      Sign sign;

      setUp(() {
        sign = new Sign(
            'AKIAIOSFODNN7EXAMPLE', 'wJalrXUtnFEMI/K7MDENG+bPxRfiCYEXAMPLEKEY');
      });

      tearDown(() {
        sign = null;
      });

      test('sign2 from exsaple from doc.', () {
        sign = new Sign(
            'AKIAIOSFODNN7EXAMPLE', 'wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY');
        var req = new Request();
        req.method = 'GET';
        req.uri = Uri.parse(
            'https://elasticmapreduce.amazonaws.com?Action=DescribeJobFlows&Version=2009-03-31');
        req.headers['Host'] = 'elasticmapreduce.amazonaws.com';
        req.headers['x-amz-date'] = '20111003T151930Z';

        req = sign.sign2(req);

        expect(
            req.uri.queryParameters['AWSAccessKeyId'], 'AKIAIOSFODNN7EXAMPLE');
        expect(req.uri.queryParameters['SignatureVersion'], '2');
        expect(req.uri.queryParameters['SignatureMethod'], 'HmacSHA256');
        expect(req.uri.queryParameters['Timestamp'], '2011-10-03T15:19:30');
        expect(req.uri.queryParameters['Signature'],
            'i91nKc4PWAt0JJIdXwz9HxZCJDdiy6cf_Mj6vPxyYIs=');
      });

      test(
          'hashHex abc => ba7816bf8f01cfea414140de5dae2223b00361a396177a9cb410ff61f20015ad',
          () {
        expect(sign.hashHex('abc'),
            'ba7816bf8f01cfea414140de5dae2223b00361a396177a9cb410ff61f20015ad');
      });

      test('version2date 20130607T080910Z = 2013-06-07T08:09:10', () {
        expect(sign.version2date('20130607T080910Z'), '2013-06-07T08:09:10');
      });

      test('getSigningKey', () {
        final scope = ['20110909', 'us-east-1', 'iam', 'aws4_request'];
        final signingKey = [
          152,
          241,
          216,
          137,
          254,
          196,
          244,
          66,
          26,
          220,
          82,
          43,
          171,
          12,
          225,
          248,
          46,
          105,
          41,
          194,
          98,
          237,
          21,
          229,
          169,
          76,
          144,
          239,
          209,
          227,
          176,
          231
        ];
        expect(sign.getSigningKey(scope), signingKey);
      });

      test('toSign a b c => AWS4-HMAC-SHA256\\na\\nb\\nc', () {
        expect(sign.toSign('a', 'b', 'c'), 'AWS4-HMAC-SHA256\na\nb\nc');
      });

      test('getScope 20000101T000000Z b c => 20000101 b c aws4_request', () {
        expect(sign.getScope('20000101T000000Z', 'b', 'c'),
            ['20000101', 'b', 'c', 'aws4_request']);
      });

      test('canonical4 a b c d e f => a\\nb\\nc\\nd\\ne\\nf', () {
        expect(
            sign.canonical4('a', 'b', 'c', 'd', 'e', 'f'), 'a\nb\nc\nd\ne\nf');
      });

      group('signedHeaders', () {
        test('[] =>', () {
          expect(sign.signedHeaders([]), '');
        });

        test('[A] => a', () {
          expect(sign.signedHeaders(['A']), 'a');
        });

        test('[d,c,b,a] => a;b;c;d', () {
          expect(sign.signedHeaders(['d', 'c', 'b', 'a']), 'a;b;c;d');
        });

        test('[abc, aBc,ABC] => abc', () {
          expect(sign.signedHeaders(['abc', 'aBc', 'ABC']), 'abc');
        });
      });

      group('canonicalHeaders', () {
        test('{} => empty string', () {
          expect(sign.canonicalHeaders({}), '');
        });

        test('{:} => :\\n', () {
          expect(sign.canonicalHeaders({'': ''}), ':\n');
        });

        test('{:} => :\\n', () {
          expect(sign.canonicalHeaders({'': ''}), ':\n');
        });

        test('{a:} => a:\\n', () {
          expect(sign.canonicalHeaders({'a': ''}), 'a:\n');
        });

        test('{a:b,c:,d:e} => a:b\\nc:\\nd:e\\n', () {
          expect(sign.canonicalHeaders({'a': 'b', 'c': '', 'd': 'e',}),
              'a:b\nc:\nd:e\n');
        });

        test('{c:t,b:t,a:t} => a:t\\nb:t\\nc:t\\n', () {
          expect(sign.canonicalHeaders({'c': 't', 'b': 't', 'a': 't',}),
              'a:t\nb:t\nc:t\n');
        });

        test('{c:t,B:t,a:t} => a:t\\nb:t\\nc:t\\n', () {
          expect(sign.canonicalHeaders({'c': 't', 'B': 't', 'a': 't',}),
              'a:t\nb:t\nc:t\n');
        });

        test('{ABC:t} => abc:t', () {
          expect(sign.canonicalHeaders({'ABC': 't'}), 'abc:t\n');
        });

        test('{a:  t   t  } => abc:t t', () {
          expect(sign.canonicalHeaders({'a': '  t  t  '}), 'a:t t\n');
        });

        test('{a:  "t   t"  } => abc:"t  t"', () {
          expect(sign.canonicalHeaders({'a': '  "t  t"  '}), 'a:"t  t"\n');
        });

        test('{abc:a, aBc:b,ABC:c} => abc:a,b,c', () {
          expect(sign.canonicalHeaders({'abc': 'a', 'aBc': 'b', 'ABC': 'c'}),
              'abc:a,b,c\n');
        });
      });

      group('canonicalPath', () {
        test('empty path => /', () {
          expect(sign.canonicalPath([]), '/');
        });

        test('[test] => /test', () {
          expect(sign.canonicalPath(['test']), '/test');
        });

        test('[root,dir,file.test] => /root/dir/file.test', () {
          expect(sign.canonicalPath(['root', 'dir', 'file.test']),
              '/root/dir/file.test');
        });

        test('[wit space] => /wit%20space', () {
          expect(sign.canonicalPath(['wit space']), '/wit%20space');
        });
      });

      group('canonicalQuery', () {
        test('{} => empty string', () {
          expect(sign.canonicalQuery({}), '');
        });

        test('{a:} => a=', () {
          expect(sign.canonicalQuery({'a': ''}), 'a=');
        });

        test('{a:b,c:,d:e} => a=b&c=&d=e', () {
          expect(sign.canonicalQuery({'a': 'b', 'c': '', 'd': 'e',}),
              'a=b&c=&d=e');
        });

        test('{c:t,b:t,a:t} => a=t&b=t&c=t', () {
          expect(sign.canonicalQuery({'c': 't', 'b': 't', 'a': 't',}),
              'a=t&b=t&c=t');
        });

        test('{c:t,B:t,a:t} => B=t&a=t&c=t', () {
          expect(sign.canonicalQuery({'c': 't', 'B': 't', 'a': 't',}),
              'B=t&a=t&c=t');
        });

        test('{ABCDEFGHIJKLMNOPQRSTUVWXYZ:} => ABCDEFGHIJKLMNOPQRSTUVWXYZ=',
            () {
          expect(sign.canonicalQuery({'ABCDEFGHIJKLMNOPQRSTUVWXYZ': '',}),
              'ABCDEFGHIJKLMNOPQRSTUVWXYZ=');
        });

        test('{abcdefghijklmnopqrstuvwxyz:} => abcdefghijklmnopqrstuvwxyz=',
            () {
          expect(sign.canonicalQuery({'abcdefghijklmnopqrstuvwxyz': '',}),
              'abcdefghijklmnopqrstuvwxyz=');
        });

        test('{0123456789:} => 0123456789=', () {
          expect(sign.canonicalQuery({'0123456789': '',}), '0123456789=');
        });

        test('{-_.~:} => -_.~=', () {
          expect(sign.canonicalQuery({'-_.~': '',}), '-_.~=');
        });

        test('{space:} => %20=', () {
          expect(sign.canonicalQuery({' ': '',}), '%20=');
        });

        test('{!"%&()*+,/;:<=>?@[\]^{|}} => %20=', () {
          expect(sign.canonicalQuery({'!"%&()*+,/;:<=>?@[\]^{|}': '',}),
              '%21%22%25%26%28%29%2A%2B%2C%2F%3B%3A%3C%3D%3E%3F%40%5B%5D%5E%7B%7C%7D=');
        });

        test('{Ø} => %20=', () {
          expect(sign.canonicalQuery({'Ø': '',}), '%C3%98=');
        });
      });
    });
