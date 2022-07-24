# ========================================================== #
# [処理名]
# IGW構築
# 
# [概要]
# IGW構築
#
# [引数]
# 変数名: u_vpc_id
# 値: VPCID
# 
# [output]
# 変数名: id
# 値: IGWID
# ========================================================== #

resource "aws_internet_gateway" "prj_dev_igw" {
  vpc_id = var.u_vpc_id
  tags = {
    Env = "dev"
    Name = "prj_dev_igw"
  }
}

output "id" {
  value = "${aws_internet_gateway.prj_dev_igw.id}"
}