

data "aws_subnets" "db_subnets" {
    filter {
      name      = "tag:Name"
      values    = ["db1","db2"]
    }
    filter {
      name      = "vpc-id"
      values    = [aws_vpc.main.id]
    }
}

data "aws_subnets" "app_subnets" {
    filter {
      name      = "tag:Name"
      values    = ["app1","app2"]
    }
    filter {
      name      = "vpc-id"
      values    = [aws_vpc.main.id]
    }
}