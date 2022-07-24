# ========================================================== #
# [処理名]
# EC2インスタンス構築
# 
# [概要]
# EC2インスタンス構築
#
# [引数]
# 変数名: u_public_subnet_id
# 値: パブリックサブネットID
# 
# 変数名: u_sg_web_id
# 値: セキュリティグループID
# 
# 変数名: u_key_name
# 値: プライベートキー名
# 
# [output]
# public_ip: パブリックIPアドレス
#
# ========================================================== #

resource "aws_instance" "server" {
  ami                    = "ami-00d101850e971728d"
  instance_type          = "t2.micro"
  subnet_id              = var.u_public_subnet_id
  vpc_security_group_ids = [var.u_sg_web_id]
  key_name               = var.u_key_name
  associate_public_ip_address = "true"
  user_data = file("${path.module}/script.sh")
  tags = {
    Env = "dev"
    Name = "web_server"
  }
}

output "public_ip" {
  value = "${aws_instance.server.public_ip}"
}