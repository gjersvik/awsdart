part of AmazoneDart;

class Sign2 {
  String metode = 'GET';
  String endpoint;
  String action;
  Map<String,String> parameters = {};
  DateTime timestamp = new DateTime.now();
  
  String sign(String accessKey, String secretKey){
    
  }
  
  String createCanonical() {
    
  }
}