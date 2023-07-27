resource "aws_codecommit_repository" "CodeCommitRepository" {
  description     = "Code repository for web application"
  repository_name = var.mybookstore-WebAssets
}



