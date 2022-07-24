#!/bin/bash
yum update -y

## Nginx　Setup
amazon-linux-extras info nginx1
sudo amazon-linux-extras install -y nginx1
sudo systemctl start nginx
sudo systemctl status nginx
sudo systemctl enable nginx