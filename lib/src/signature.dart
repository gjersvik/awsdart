part of awsdart;

String canonicalPath(List<String> path){
  return '/' + new Uri(pathSegments: path).path;
}
