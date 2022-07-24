# ========================================================== #
# [処理名]
# ネットワークACL構築
# 
# [概要]
# ネットワークACL構築
# ・インバウンドルール
#    接続元:0.0.0.0/0
#    ポート:全プロトコル
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
# ========================================================== #
resource "aws_network_acl" "prj_dev_acl_web" {
  vpc_id = var.u_vpc_id
  subnet_ids = [var.u_public_subnet_id]
  tags = {
    Env = "dev"
    Name = "prj_dev_acl_web"
  }
}

resource "aws_network_acl_rule" "inboud_rule" {
  network_acl_id = "${aws_network_acl.prj_dev_acl_web.id}"
  rule_number    = 100
  egress         = false
  protocol       = "all"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
}

resource "aws_network_acl_rule" "outbound_rule" {
  network_acl_id = "${aws_network_acl.prj_dev_acl_web.id}"
  rule_number    = 100
  egress         = true
  protocol       = "all"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
}
