part of awsdart;

class Service{
  const Service appStream = const Service('Amazon AppStream','appstream');
  const Service awsPortal = const Service('AWS Billing and Cost Management','aws-portal');
  const Service cloudFormation = const Service('AWS CloudFormation','cloudformation');
  const Service cloudFront = const Service('Amazon CloudFront','cloudfront');
  const Service cloudSearch = const Service('Amazon CloudSearch','cloudsearch');
  const Service cloudTrail = const Service('AWS CloudTrail','cloudtrail');
  const Service cloudWatch = const Service('CloudWatch','cloudwatch');
  const Service codeDeploy = const Service('AWS CodeDeploy','codedeploy');
  const Service config = const Service('AWS Config','config');
  const Service cognito = const Service('Amazon Cognito','cognito-identity');
  const Service cognitoSync = const Service('Amazon Cognito Sync','cognito-sync');
  const Service dataPipeline = const Service('AWS Data Pipeline','datapipeline');
  const Service directConnect = const Service('AWS Direct Connect','directconnect');
  const Service ds = const Service('AWS Directory Service','ds');
  const Service dynamodb = const Service('DynamoDB','dynamodb');
  const Service ec2 = const Service('Amazon EC2','ec2');
  const Service elasticBeanstalk = const Service('AWS Elastic Beanstalk','elasticbeanstalk');
  const Service elasticLoadBalancing = const Service('Elastic Load Balancing','elasticloadbalancing');
  const Service elasticMapReduce = const Service('Amazon Elastic MapReduce','elasticmapreduce');
  const Service elastiCache = const Service('Amazon ElastiCache','elasticache');
  const Service elasticTranscoder = const Service('Amazon Elastic Transcoder','elastictranscoder');
  const Service glacier = const Service('Amazon Glacier','glacier');
  const Service iam = const Service('AWS Identity and Access Management','iam');
  const Service importExport = const Service('AWS Import/Export','importexport');
  const Service kinesis = const Service('Amazon Kinesis','kinesis');
  const Service kms = const Service('AWS Key Management Service','kms');
  const Service marketplace = const Service('AWS Marketplace','aws-marketplace');
  const Service marketplaceManagement = const Service('AWS Marketplace Management Portal','aws-marketplace-management');
  const Service mobileanAlytics = const Service('Amazon Mobile Analytics','mobileanalytics');
  const Service opsWorks = const Service('AWS OpsWorks','opsworks');
  const Service rds = const Service('Amazon RDS','rds');
  const Service redshift = const Service('Amazon Redshift','redshift');
  const Service route53 = const Service('Amazon Route 53','route53');
  const Service s3 = const Service('Amazon S3','s3');
  const Service ses = const Service('Amazon SES','ses');
  const Service simpledb = const Service('Amazon SimpleDB','sdb');
  const Service sns = const Service('Amazon SNS','sns');
  const Service sqs = const Service('Amazon SQS','sqs');
  const Service storageGateway = const Service('AWS Storage Gateway','storagegateway');
  const Service sts = const Service('AWS STS','sts');
  const Service support = const Service('AWS Support','support');
  const Service swf = const Service('Amazon SWF','swf');
  const Service trustedAdvisor = const Service('AWS Trusted Advisor','trustedadvisor');
  const Service ec2 = const Service('Amazon VPC','ec2');
  const Service workspaces = const Service('Amazon WorkSpaces','workspaces');
  
  final String name;
  final String identifier;
  
  const Service(this.name, this.identifier);
  
  String toString() => name;
}