#key-pair(login key) for ec2 instance
resource "aws_key_pair" "my_key" {
  key_name   = "portfolio-ec2-key-1"
  public_key = var.public_key
}

#VPC and Security group for ec2 instance
resource "aws_default_vpc" "default" {
  tags = {
    Name = "Default VPC"

  }
}

#security group for ec2 instance
resource "aws_security_group" "my_security_group" {
  name        = "web-security-group"
  description = "This is security group which allows inbound and outbound traffic for EC2 instance"
  vpc_id      = aws_default_vpc.default.id


#inbound and outbound rules for security group
   dynamic "ingress" {
    for_each = var.ingress_rules
    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
      description = ingress.value.description
    }
  }

  dynamic "egress" {
    for_each = var.egress_rules
    content {
      from_port   = egress.value.from_port
      to_port     = egress.value.to_port
      protocol    = egress.value.protocol
      cidr_blocks = egress.value.cidr_blocks
      description = egress.value.description
    }
  }

  tags = {
    Name  = "web-security-group"
    
  }
}

#ec2 instance
resource "aws_instance" "my_instance" {
  #count = var.instance_count 
    ami = var.ec2_ami_id
    instance_type = var.ec2_instance_type
    key_name = aws_key_pair.my_key.key_name
    vpc_security_group_ids = [aws_security_group.my_security_group.id]
    user_data = file("${path.module}/user_data.sh")

    root_block_device {
      volume_size = var.ec2_root_storage
      volume_type = "gp3"
    }
    
    tags = {
    Name = "portfolio-ec2-instance"
    }
  }

  
