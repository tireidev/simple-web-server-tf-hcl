# ========================================================== #
# [処理名]
# セキュリティグループ構築
# 
# [概要]
# セキュリティグループ構築
# ・インバウンドルール
#    接続元:MyIP
#    ポート:22(TCP)、80(TCP)
#
# ・アウトバウンドルール
#    接続先:0.0.0.0/0
#    ポート:全プロトコル
#
# [引数]
# 変数名: u_vpc_id
# 値: VPCID
# 
# 変数名: u_public_subnet_ip
# 値: パブリックサブネットIPアドレス
# 
# [output]
# なし
#
# ========================================================== #

resource "aws_security_group" "prj_dev_sg_web" {
  name        = "prj_dev_sg_web"
  description = "Allow http and https traffic."
  vpc_id      = var.u_vpc_id

  tags = {
    Env = "dev"
    Name = "prj_dev_sg_web"
  }
  # インバウンドルールはaws_security_group_ruleにて定義
}

# 22番ポート許可のインバウンドルール
resource "aws_security_group_rule" "ingress_allow_22" {
  type        = "ingress"
  from_port   = 22
  to_port     = 22
  protocol    = "tcp"
  cidr_blocks = [var.u_allowed_cidr_myip]

  # セキュリティグループと紐付け
  security_group_id = "${aws_security_group.prj_dev_sg_web.id}"
}

# 80番ポート許可のインバウンドルール
resource "aws_security_group_rule" "ingress_allow_80" {
  type        = "ingress"
  from_port   = 80
  to_port     = 80
  protocol    = "tcp"
  cidr_blocks = [var.u_allowed_cidr_myip]

  # セキュリティグループと紐付け
  security_group_id = "${aws_security_group.prj_dev_sg_web.id}"
}

# アウトバウンドルール
resource "aws_security_group_rule" "egress_allow_all" {
  type        = "egress"
  from_port   = 0
  to_port     = 0
  protocol    = "all"
  cidr_blocks = ["0.0.0.0/0"]

  # セキュリティグループと紐付け
  security_group_id = "${aws_security_group.prj_dev_sg_web.id}"
}

# resource "aws_security_group" "prj_dev_sg_web" {
#   name        = "prj_dev_sg_web"
#   description = "security group for web server"
#   vpc_id      = var.u_vpc_id

#   ingress {
#     description = ""
#     from_port   = 22
#     to_port     = 22
#     protocol    = "tcp"
#     cidr_blocks = [local.allowed-cidr-myip]
#   }

#   egress {
#     from_port        = 0
#     to_port          = 0
#     protocol         = "-1"
#     cidr_blocks      = ["0.0.0.0/0"]
#     ipv6_cidr_blocks = ["::/0"]
#   }

#   tags = {
#     env = "dev"
#     Name = "allow_ssh"
#   }
# }

output "sg_web_id" {
  value = "${aws_security_group.prj_dev_sg_web.id}"
}