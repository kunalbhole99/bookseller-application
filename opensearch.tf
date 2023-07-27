
resource "aws_elasticsearch_domain" "OpenSearchServiceDomain" {
  domain_name           = var.mybookstore-domain
  elasticsearch_version = "OpenSearch_1.3"
  cluster_config {
    dedicated_master_enabled = false
    instance_count           = 1
    instance_type            = "t3.small.elasticsearch"
    zone_awareness_enabled   = false
  }
  access_policies = "{\"Version\":\"2012-10-17\",\"Statement\":[{\"Effect\":\"Allow\",\"Principal\":{\"AWS\":\"*\"},\"Action\":\"es:*\",\"Resource\":\"arn:aws:es:us-east-1:${var.account_id}:domain/${var.mybookstore-domain}/*\"}]}"
  vpc_options {
    security_group_ids = [
      aws_security_group.custom_default_sg.id
    ]
    subnet_ids = [
      aws_subnet.EC2Subnet1.id
    ]
  }
  encrypt_at_rest {
    enabled = false
  }
  node_to_node_encryption {
    enabled = false
  }
  advanced_options = {
    override_main_response_version           = "false"
    "rest.action.multi.allow_explicit_index" = "true"
  }
  ebs_options {
    ebs_enabled = true
    volume_type = "gp2"
    volume_size = 100
    iops        = 0
  }
}
