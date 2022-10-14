variable "aws_vpc_main_cidr" {
    type = string
    default = "192.168.0.0/16"
  
}

variable "aws_subnet_names" {
    type = list(string)
    default = [ "web1","web2","db1","db2","app1","app2" ]
}

variable "aws_dbsubnet_names" {
    type = list(string)
    default = [ "db1","db2" ]

}

variable "aws_subnets_azs" {
    type = list(string)
    default = [ "ap-southeast-1a","ap-southeast-1b","ap-southeast-1a","ap-southeast-1b","ap-southeast-1a","ap-southeast-1b" ]
  
}

variable "db_instance_info" {
    type = object({
        allocated_storage       = number
         engine                 = string
          engine_version        = string
          instance_class        = string
          name                  = string
           username             = string
           password             = string
           skip_final_snapshot  = bool
   })
   default = {
     
         allocated_storage = 10
         engine               = "mysql"
          engine_version       = "5.7"
          instance_class       = "db.t3.micro"
          name                 = "mydb"
           username             = "football"
           password             = "indianfootball"
           skip_final_snapshot  = true
  
    }
}

 variable "app_server_info" {
    type                            = object({
        key_name                    = string
        public_key_path             = string
        count                       = number
        ami                         = string
        instance_type               = string
        associate_public_ip_address = bool
        Name                        = string
    })
    default = {
      key_name                       = "my_key_pair"
        public_key_path              = "~/.ssh/id_rsa.pub"
        count                        = 2
        ami                          = "ami-02ee763250491e04a"
        instance_type                = "t2.micro"
        associate_public_ip_address  = false
        Name                         = "appserver"
   
    }
 }
