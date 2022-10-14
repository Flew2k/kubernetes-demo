# AWS EC2 Instance Terraform Module
# Bastion Host - EC2 Instance that will be created in VPC Public Subnet
module "ec2_public" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "3.3.0"
  # insert the required variables here
  name          = "EKS-BastionHost"
  ami           = data.aws_ami.amzlinux2.id
  instance_type = var.instance_type
  #monitoring             = true
  subnet_id              = module.vpc.public_subnets[0]
  vpc_security_group_ids = [module.public_bastion_sg.security_group_id]
  tags = {
    owner = "Dulguun"
  }
  user_data = <<EOF
  #! /bin/bash
  # Instance Identity Metadata Reference - https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/instance-identity-documents.html
  set -o xtrace
  /etc/eks/bootstrap.sh demo
  sudo yum update -y
  sudo yum install -y httpd
  sudo systemctl enable httpd
  sudo service httpd start  
  sudo echo '<h1>Welcome to StackSimplify - APP-1</h1>' | sudo tee /var/www/html/index.html
  sudo mkdir /var/www/html/app1
  sudo echo '<!DOCTYPE html> <html> <body style="background-color:rgb(250, 210, 210);"> <h1>Welcome to Stack Simplify - APP-1</h1> <p>Terraform Demo</p> <p>Application Version: V1</p> </body></html>' | sudo tee /var/www/html/app1/index.html
  sudo curl http://169.254.169.254/latest/dynamic/instance-identity/document -o /var/www/html/app1/metadata.html
  EOF
}
