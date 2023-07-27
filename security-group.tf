resource "aws_security_group" "neptunedb_sg" {
  description = "Security group for Neptune DB within book store app."
  name        = "mybookstore-bookstoreNeptuneSecurityGroup-TDOCZRJTWSQA"
  tags = {
    Name = "neptunedb_sg"
  }
  vpc_id = aws_vpc.EC2VPC.id
  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 8182
    protocol    = "tcp"
    to_port     = 8182
  }
  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
  }
}

resource "aws_security_group" "elasticache_sg" {
  description = "Elasticache security group"
  name        = "mybookstore-bookstoreCacheSecurityGroup-1PEQCCTLLPH53"
  tags = {
    Name = "elasticache_sg"
  }
  vpc_id = aws_vpc.EC2VPC.id
  ingress {
    security_groups = [aws_security_group.redis_sg.id]
    from_port       = 6379
    protocol        = "tcp"
    to_port         = 6379
  }
  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
  }
}

resource "aws_security_group" "redis_sg" {
  description = "A component security group allowing access only to redis"
  name        = "mybookstore-redisLambdaSecurityGroup-FVMNKWPD6810"
  tags = {
    Name = "redis_sg"
  }
  vpc_id = aws_vpc.EC2VPC.id
  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
  }
}


resource "aws_security_group" "custom_default_sg" {
  description = "custom default security group"
  name        = "mybookstore-bookstore-custom-default-SecurityGroup"
  tags = {
    Name = "custom-default-sg"
  }
  vpc_id = aws_vpc.EC2VPC.id
  ingress {
    self      = true
    from_port = 0
    protocol  = "-1"
    to_port   = 0
  }
  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
  }
}