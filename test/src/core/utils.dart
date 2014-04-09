part of awsdart_core_unit;

utilsTest() => group('utils',(){
  test('bytesToHex => hexToBytes round trip',(){
    var bytes0_255 = new List.generate(256, (i) => i);
    var hex = bytesToHex(bytes0_255);
    expect(hexToBytes(hex), bytes0_255);
  });
});