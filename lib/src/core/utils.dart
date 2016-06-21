part of awsdart_core;

List<int> hexToBytes(String hex) {
  hex = hex.toLowerCase();
  final reqex = new RegExp('[0-9a-f]{2}');
  return reqex
      .allMatches(hex.toLowerCase())
      .map((Match match) => int.parse(match.group(0), radix: 16))
      .toList();
}

String bytesToHex(List<int> bytes) => hex.encode(bytes);

String hostnameToService(String host) {
  String service = host.split('.').first;

  //s3 is spesial.
  if (service.startsWith('s3')) {
    service = 's3';
  }

  return service;
}

String hostnameToRegion(String host) {
  var labels = host.split('.');
  if (labels.length == 4) {
    return labels[1];
  }

  //s3 is spesial.
  if (labels.first.startsWith('s3')) {
    var s3 = labels.first;
    if (s3.length > 2) {
      s3 = s3.replaceFirst('s3-', '');
      if (s3 != 'external-1') {
        return s3;
      }
    }
  }

  return 'us-east-1';
}
