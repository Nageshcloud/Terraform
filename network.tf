resource "aws_vpc" "main" {
  cidr_block       = var.aws_vpc_main_cidr
  tags = {
    Name = "main"
  }
}

resource "aws_subnet" "subnets" {
  count             = length(var.aws_subnet_names)
  vpc_id            = aws_vpc.main.id
  cidr_block    = cidrsubnet(var.aws_vpc_main_cidr,8,count.index)
  availability_zone = var.aws_subnets_azs[count.index]

  tags = {
    Name = var.aws_subnet_names[count.index]
  }
}
resource "aws_security_group" "app_secur_grp" {
  vpc_id             = aws_vpc.main.id
  ingress {
    from_port        = local.ssh_port
    to_port          = local.ssh_port
    protocol         = local.tcp
    cidr_blocks      = [local.anywhere]
  }

 ingress {
    from_port        = local.app_port
    to_port          = local.app_port
    protocol         = local.tcp
    cidr_blocks      = [local.anywhere]
  }

  egress {
    from_port        = local.any_port
    to_port          = local.any_port
    protocol         = local.any_protocol
    cidr_blocks      = [local.anywhere]
    ipv6_cidr_blocks = [local.anywhere_ipv6]
  }

  tags = {
    Name = "app_secur_grp"
  }
}
resource "aws_db_subnet_group" "db_subnet_group" {
    name        =  "db_subnet_group"
    subnet_ids  =  data.aws_subnets.db_subnets.ids
    depends_on = [
      aws_subnet.subnets
    ]
}

resource "aws_db_instance" "default" {
  allocated_storage    = var.db_instance_info.allocated_storage
 db_subnet_group_name  = aws_db_subnet_group.db_subnet_group.name
  engine               = var.db_instance_info.engine
  engine_version       = var.db_instance_info.engine_version
  instance_class       = var.db_instance_info.instance_class
  db_name              = var.db_instance_info.name
  username             = var.db_instance_info.username
  password             = var.db_instance_info.password
  skip_final_snapshot  = true
}


resource "aws_key_pair" "my_key_pair" {
  key_name   = var.app_server_info.key_name
  public_key = file(var.app_server_info.public_key_path)
}

resource "aws_instance" "app_server" {
  count                       = var.app_server_info.count
  ami                         = var.app_server_info.ami
  instance_type               = var.app_server_info.instance_type
  key_name                    = var.app_server_info.key_name
  vpc_security_group_ids      = [ aws_security_group.app_secur_grp.id]
  subnet_id                   = data.aws_subnets.app_subnets.ids[count.index]
  associate_public_ip_address = var.app_server_info.associate_public_ip_address
 
  tags                        = {
    Name                      = var.app_server_info.Name
  }
  provisioner "remote-exec" {
    inline = [
      "#!/bin/bash",
      "sudo apt update"
    ]
    
  }
  connection {
      type        = "ssh"
      host        = self.public_ip
      user        = "ubuntu"
      private_key = file("~/.ssh/id_rsa.pub")
      timeout     = "1m"
    }
}