# ========================================================== #
# [処理名]
# メイン処理
# 
# [概要]
# AWS上のパブリックサブネットにNginxを構築する
# 
# [手順]
# 0. プロバイダ設定(AWS)
# 1. ネットワーク構築
#   1.1. VPC構築
#   1.2. IGW構築
#   1.3. RouteTable構築
#   1.4. Subnet構築
#   1.5. RouteTableとPublic Subnetの紐付け
# 2. セキュリティ設定
#   2.1. MyIP取得
#   2.2. ネットワークACL構築
#   2.3. セキュリティグループ構築
#   2.4. キーペア構築 ※EC2インスタンスのSSH接続で利用するため
# 3. EC2インスタンス構築
# ========================================================== #

# ========================================================== #
# 0. プロバイダ設定(AWS)
# ========================================================== #
provider "aws" {
  region = var.u_aws_region
}

# ========================================================== #
# 1. ネットワーク構築
# ========================================================== #
#   1.1. VPC構築
# ========================================================== #
module "aws_vpc" {
  source       = "./modules/network/aws_vpc"
  u_vpc_ip_ip4 = var.u_aws_vpc_cidr
}

# ========================================================== #
#   1.2. IGW構築
# ========================================================== #
module "aws_internet_gateway" {
  source   = "./modules/network/aws_internet_gateway"
  u_vpc_id = module.aws_vpc.id
}

# ========================================================== #
#   1.3. RouteTable構築
# ========================================================== #
module "aws_route_table" {
  source                = "./modules/network/aws_route_table"
  u_vpc_id              = module.aws_vpc.id
  u_internet_gateway_id = module.aws_internet_gateway.id
}

# ========================================================== #
#   1.4. Subnet構築
# ========================================================== #
module "aws_subnet" {
  source             = "./modules/network/aws_subnet"
  u_vpc_id           = module.aws_vpc.id
  u_public_subnet_ip = var.u_public_subnet_ip
}

# ========================================================== #
#   1.5. RouteTableとPublic Subnetの紐付け
# ========================================================== #
module "aws_route_table_association" {
  source               = "./modules/network/aws_route_table_association"
  u_aws_route_table_id = module.aws_route_table.id
  u_public_subnet_id   = module.aws_subnet.public_subnet_id
}

# ========================================================== #
# 2. セキュリティ設定
# ========================================================== #
#   2.1. MyIP取得
# ========================================================== #
module "cidr_myip" {
  source   = "./modules/network/cidr_myip"
  u_allowed_cidr_myip = var.u_allowed_cidr_myip
}

# ========================================================== #
#   2.2. ネットワークACL構築
# ========================================================== #
module "aws_network_acl" {
  source   = "./modules/security/aws_network_acl"
  u_vpc_id = module.aws_vpc.id
  u_public_subnet_id = module.aws_subnet.public_subnet_id
}

# ========================================================== #
#   2.3. セキュリティグループ構築
# ========================================================== #
module "aws_security_group" {
  source   = "./modules/security/aws_security_group"
  u_vpc_id = module.aws_vpc.id
  u_allowed_cidr_myip = module.cidr_myip.ip
}

# ========================================================== #
#   2.4. キーペア構築 ※EC2インスタンスのSSH接続で利用するため
# ========================================================== #
module "aws_key_pairs" {
  source             = "./modules/security/aws_key_pairs"
  u_key_name         = var.u_key_name
  u_private_key_name = var.u_private_key_name
  u_public_key_name  = var.u_public_key_name
}

# ========================================================== #
# 3. EC2インスタンス構築
# ========================================================== #
module "ec2" {
  source             = "./modules/webserver"
  u_public_subnet_id = module.aws_subnet.public_subnet_id
  u_sg_web_id        = module.aws_security_group.sg_web_id
  u_key_name         = module.aws_key_pairs.key_name
}