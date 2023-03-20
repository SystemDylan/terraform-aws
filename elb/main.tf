# Instantiate the fortune-dynamo autoscaling group module
module "asg-fortune-dynamo" {
  source = "./modules/asg-fortune-dynamo"       # The source path of the asg-fortune-dynamo module
  subnet1 = var.subnet1                         # The first subnet ID for the autoscaling group
  subnet2 = var.subnet2                         # The second subnet ID for the autoscaling group
  security_group1_id = var.security_group1_id   # The security group ID to be attached to the instances
  fortune_dynamo_ami = var.fortune_dynamo_ami   # The AMI ID for the fortune-dynamo application
  vpc_id = var.vpc_id                           # The VPC ID where the autoscaling group will be launched
  keyname = var.keyname                         # The key pair name for the instances
  dns_zone_id = var.dns_zone_id                 # The Route 53 hosted zone ID for DNS records
  fortune_dynamo_DNS = var.fortune_dynamo_DNS   # The DNS name for the fortune-dynamo application
  certificate_arn = module.acm_wildcard_certificate.certificate_arn # The ARN of the SSL certificate to be used with the load balancer
}

# Instantiate the fortune-SQL autoscaling group module
module "asg-fortune-SQL" {
  source = "./modules/asg-fortune-SQL"         # The source path of the asg-fortune-SQL module
  subnet1 = var.subnet1                        # The first subnet ID for the autoscaling group
  subnet2 = var.subnet2                        # The second subnet ID for the autoscaling group
  security_group1_id = var.security_group1_id  # The security group ID to be attached to the instances
  fortune_SQL_ami = var.fortune_SQL_ami        # The AMI ID for the fortune-SQL application
  vpc_id = var.vpc_id                          # The VPC ID where the autoscaling group will be launched
  keyname = var.keyname                        # The key pair name for the instances
  dns_zone_id = var.dns_zone_id                # The Route 53 hosted zone ID for DNS records
  fortune_SQL_DNS = var.fortune_SQL_DNS        # The DNS name for the fortune-SQL application
  certificate_arn = module.acm_wildcard_certificate.certificate_arn # The ARN of the SSL certificate to be used with the load balancer
}

# Instantiate the ACM wildcard SSL certificate module
module "acm_wildcard_certificate" {
  source = "./modules/acm-wildcard-certificate" # The source path of the acm-wildcard-certificate module
  domain_name = var.domain_name                 # The domain name to create a wildcard SSL certificate for (*.example.com)
  dns_zone_id = var.dns_zone_id                 # The Route 53 hosted zone ID for DNS records
}
