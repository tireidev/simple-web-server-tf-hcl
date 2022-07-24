# ========================================================== #
# [処理名]
# Subnet構築
# 
# [概要]
# Subnet構築
#
# [引数]
# 変数名: u_vpc_id
# 値: VPCID
# 
# 変数名: u_public_subnet_ip
# 値: パブリックサブネットIPアドレス
# 
# [output]
# 変数名: public_subnet_id
# 値: パブリックサブネットIPアドレス
#
# ========================================================== #

resource "aws_subnet" "public_subnet" {
  vpc_id = var.u_vpc_id
  cidr_block = var.u_public_subnet_ip

  tags = {
    Env = "dev"
    Name = "prj_dev_public_subnet"
  }
}

output "public_subnet_id" {
  value = "${aws_subnet.public_subnet.id}"
}

# resource "aws_subnet" "private_subnet" {
#   vpc_id = var.u_vpc_id
#   cidr_block = var.u_private_subnet_ip

#   tags = {
#     Name = "private_subnet"
#   }
# }

# output "private_subnet_id" {
#   value = "${aws_subnet.private_subnet.id}"
# }
