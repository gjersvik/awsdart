part of amazone_dart;

class Sign2{
  String canonicalQueryString(String metode, Uri uri){
    var canon = new StringBuffer();
    
    // Start with the request method, followed by a newline character.
    canon.writeln(metode);
    
    // HTTP host header in lowercase, followed by a newline character.
    canon.writeln(uri.authority);
    
    // Add the URL-encoded version of each path segment of the URI
    var path = uri.pathSegments.map(Uri.encodeComponent).join('/');
    canon.writeln('/$path');
    
    //Add the query string components as UTF-8 characters which are URL encoded
    //and sorted using lexicographic byte ordering.
    var query = uri.queryParameters;
    var keys = query.keys.toList();
    keys.sort(); 
    canon.write(keys.map((String key){
      return Uri.encodeComponent(key) +'='+ Uri.encodeComponent(query[key]);
    }).join('&'));
    
    return canon.toString();
  }
}