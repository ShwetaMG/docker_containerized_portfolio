
#public key for ec2 instance
variable "public_key" {
  description = "Public key content for the EC2 key pair (contents of .pub file)"
  default     = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIO/HXypsVnp9hAbVVEuFqahHLgZGZfeEt0Pi01jU9LNv dell@DESKTOP-ALU2NF1"
  type        = string
}


#ec2 instance type
variable "ec2_instance_type"{
    description = "This variable is for ec2 instance type"
    default = "t3.micro"
    type        = string
}

#ec2 ami id
variable "ec2_ami_id"{
    description = "This variable is for ec2 ami id"
    default = "ami-01a00762f46d584a1"
    type        = string
}

#ec2 root storage
variable "ec2_root_storage"{
    description = "This variable is for ec2 root storage"
    default = 8
    type        = number
}

#inbound and outbound rules for security group
variable "ingress_rules" {
  description = "List of ingress rules for the security group"
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
    description = optional(string, "")
  }))
  default = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "SSH access"
    },
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "HTTP access"
    },
    {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "HTTPs access"
    },
    {
      from_port   = 8080
      to_port     = 8080
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "website access"
    }
  ]
}

variable "egress_rules" {
  description = "List of egress rules for the security group"
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
    description = optional(string, "")
  }))
  default = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
      description = "Allow all outbound traffic"
    }
  ]
}



