module "asg-fortune-dynamo" {
  source = "./modules/asg-fortune-dynamo"
  subnet1 = var.subnet1
  subnet2 = var.subnet2
  security_group1_id = var.security_group1_id
  fortune_dynamo_ami = var.fortune_dynamo_ami
  vpc_id = var.vpc_id
  keyname = var.keyname
  dns_zone_id = var.dns_zone_id
  fortune_dynamo_DNS = var.fortune_dynamo_DNS
}

module "asg-fortune-SQL" {
  source = "./modules/asg-fortune-SQL"
  subnet1 = var.subnet1
  subnet2 = var.subnet2
  security_group1_id = var.security_group1_id
  fortune_SQL_ami = var.fortune_SQL_ami
  vpc_id = var.vpc_id 
  keyname = var.keyname
  dns_zone_id = var.dns_zone_id
  fortune_SQL_DNS = var.fortune_SQL_DNS
}
