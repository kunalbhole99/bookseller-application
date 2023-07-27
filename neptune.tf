/*

resource "aws_neptune_cluster" "bookstoreNeptuneCluster" {
  iam_database_authentication_enabled = false
  db_subnet_group_name                = aws_neptune_subnet_group.bookstoreNeptuneSubnetGroup.id
  vpc_security_group_ids              = [aws_security_group.bookstoreNeptuneSecurityGroup.id]
}

resource "aws_neptune_instance" "bookstoreNeptuneDB" {
  db_cluster_identifier = aws_neptune_cluster.bookstoreNeptuneCluster.id
  db_instance_class     = "db.r6g.large"
}



*/

# subnet group for neptune database:

resource "aws_neptune_subnet_group" "NeptuneDBSubnetGroup" {
  name        = "bookstoreneptunesubnetgroup-keba9bryidxa"
  description = "Subnet group for Neptune DB within book store app."
  subnet_ids = [
    aws_subnet.EC2Subnet1.id,
    aws_subnet.EC2Subnet2.id
  ]
}

# Neptune database cluster:

resource "aws_neptune_cluster" "NeptuneDBCluster" {
  availability_zones = [
    "us-east-1b",
    "us-east-1a"
  ]

  lifecycle {
    ignore_changes = [
      availability_zones # Ignore the change in AZ
    ]
  }

  backup_retention_period              = 1
  cluster_identifier                   = "neptunedbcluster-x4kv4dotqbs7"
  neptune_cluster_parameter_group_name = "default.neptune1.2"
  skip_final_snapshot                  = true
  iam_roles = [
    aws_iam_role.mybookstore-bookstoreNeptuneLoaderS3ReadRole.arn
  ]
  #final_snapshot_identifier = "my-final-snapshot"
  neptune_subnet_group_name    = aws_neptune_subnet_group.NeptuneDBSubnetGroup.name
  port                         = 8182
  preferred_backup_window      = "16:35-17:05"
  preferred_maintenance_window = "wed:05:06-wed:05:36"
  vpc_security_group_ids = [
    aws_security_group.neptunedb_sg.id
  ]
  storage_encrypted                   = false
  iam_database_authentication_enabled = false
}

# Neptune Database Instance:

resource "aws_neptune_cluster_instance" "NeptuneDBInstance" {
  identifier                   = "bookstoreneptunedb-z1dgo14x6idd"
  instance_class               = "db.t3.medium"
  neptune_subnet_group_name    = aws_neptune_subnet_group.NeptuneDBSubnetGroup.name
  preferred_maintenance_window = "sun:05:39-sun:06:09"
  neptune_parameter_group_name = "default.neptune1.2"
  auto_minor_version_upgrade   = false
  cluster_identifier           = aws_neptune_cluster.NeptuneDBCluster.cluster_identifier
}


