# creation of Elasticache subnet group :


resource "aws_elasticache_subnet_group" "ElastiCacheSubnetGroup" {
  description = "Subnets for ElastiCache"
  name        = "mybookstore-bookstorecachesubnets-feexos9yvcqx"
  subnet_ids  = [aws_subnet.EC2Subnet2.id]
}

# creation of elasticache cluster:

resource "aws_elasticache_cluster" "ElastiCacheCacheCluster" {
  node_type = "cache.t2.micro"
  engine    = "redis"
  #engine_version_actual = "7.0.7"
  num_cache_nodes      = 1
  availability_zone    = "us-east-1a"
  maintenance_window   = "tue:06:30-tue:07:30"
  parameter_group_name = "default.redis7"
  subnet_group_name    = aws_elasticache_subnet_group.ElastiCacheSubnetGroup.name
  security_group_ids = [
    aws_security_group.elasticache_sg.id
  ]
  snapshot_retention_limit = 0
  snapshot_window          = "03:00-04:00"
  cluster_id               = "mybookstore-cluster"
}

