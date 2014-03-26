part of awsdart;

List<int> hexToBytes(String hex){
  hex = hex.toLowerCase();
  final reqex = new RegExp('[0-9a-f]{2}');
  return reqex.allMatches(hex.toLowerCase()).map((Match match) 
      => int.parse(match.group(0), radix: 16)).toList();
}

String bytesToHex(List<int> bytes) => CryptoUtils.bytesToHex(bytes);