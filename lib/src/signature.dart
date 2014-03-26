part of awsdart;

String canonicalPath(List<String> path){
  return '/' + new Uri(pathSegments: path).path;
}

String canonicalQuery(Map<String,String> query){
  var keys = query.keys.toList();
  keys.sort(); 
  return keys.map((String key){
    return awsUriEncode(key) +'='+ awsUriEncode(query[key]);
  }).join('&');
}

String awsUriEncode(String data){
  var code = Uri.encodeComponent(data);
  code = code.replaceAll('!', '%21');
  code = code.replaceAll('(', '%28');
  code = code.replaceAll(')', '%29');
  code = code.replaceAll('*', '%2A');
  return code;
}
