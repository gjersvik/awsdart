/* Uses the lowest level aws api to run and terminate an t2.mirco instance.
 * This is a very low level and require deep knowledge of the inner working of 
 * the aws api. But on the plus side it gives you complete control and access 
 * to the newest features.
 */

// Stander includes.
import 'dart:async';
import 'dart:convert';
import 'package:xml/xml.dart';

// We are using the io version for this exsampel.
import 'package:awsdart/io.dart';

// Import ACSSES_KEY and SECRET_KEY.
// Edit this file if you want to run the any example.
import 'keys.dart';

// These values must most likely change to your environment.
const AMI = 'ami-892fe1fe';
const VPC = 'subnet-9efae2d8';

main() {
  // Sets the Aws class to use the IO backend.
  setupAwsIO();

  // Creates a new Aws instance with the keys from keys.dart.
  Aws aws = new Aws(accessKey: ACSSES_KEY, secretKey: SECRET_KEY);

  // Since most ec2 call follow the same pattern we create a helper metode
  Future<XmlDocument> ec2Request(Map parameters) {
    // Aws ec2 takes its argument as a giant get call.
    // So we create this monster url.
    var uri = new Uri.https('ec2.$REGION.amazonaws.com', '/', parameters);
    /* Sends the request. Don’t need to pass anything else 
     * Aws.request is smart enough to figure out what its need on its own. 
     * At least for this simple case. The other arguments are mostly overrides.
     */
    return aws.request(uri).then((Response res) {
      // For aws ec2 all the responses is xml even the errors so its safe to
      // parse first.
      var doc = parse(UTF8.decode(res.body));
      //Pretty print the xml to the console to help playing and debugging.
      print(doc.toXmlString(pretty: true));

      // If the result is not 200 we throw the doc instead of returning to stop
      // the request chain.
      if (res.statusCode != 200) {
        print(res.statusCode);
        throw doc;
      } else {
        return doc;
      }
    });
  }

  /* Create a map to represent the first create request.
   * This is the least amount to start one t2.micro instance. 
   * http://docs.aws.amazon.com/AWSEC2/latest/APIReference/ApiReference-ItemType-RunningInstancesItemType.html
   */
  var create = {
    'Action': 'RunInstances',
    'ImageId': AMI,
    'InstanceType': 't2.micro',
    'MinCount': '1',
    'MaxCount': '1',
    'SubnetId': VPC,
    'Version': '2014-06-15'
  };

  print('!!!Creating instance!!!');
  //Send the request to aws and wait for the reply.
  ec2Request(create).then((XmlDocument doc) {
    // Gets the instance id out of the big xml document returned.
    // To terminate we only need its id.
    var instanceId = doc.findAllElements('instanceId').first.text;
    print('!!!$instanceId created!!!');
    print('!!!Terminate $instanceId!!!');

    // Creates the map for the termiate resuest.
    // http://docs.aws.amazon.com/AWSEC2/latest/APIReference/ApiReference-query-TerminateInstances.html
    var terminate = {
      'Action': 'TerminateInstances',
      'InstanceId.1': instanceId,
      'Version': '2014-06-15'
    };
    return ec2Request(terminate);
  }).then((XmlDocument doc) {
    //Just print out. That the code is successful and you are a few cents poorer.
    var instanceId = doc.findAllElements('instanceId').first.text;
    print('!!!$instanceId terminated!!!');
  });
}
/* Remember to log in to your management console and check that the instances
 * atulay was terminated. Especially if you have played around with the code.
 * Remember on the aws platform bugs cost real money.
 */
