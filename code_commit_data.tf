resource "null_resource" "Clone_Repo" {
  provisioner "local-exec" {

    command = <<-EOT
      git clone ${aws_codecommit_repository.CodeCommitRepository.clone_url_http} 
    EOT
  }
  depends_on = [
    aws_codecommit_repository.CodeCommitRepository,
    aws_codebuild_project.CodeBuildProject,
    aws_codepipeline.CodePipelinePipeline,
    aws_s3_bucket.S3Bucket,
    aws_cloudfront_distribution.CloudFrontDistribution

  ]
}

resource "null_resource" "Copy_data_to_local_repo" {
  provisioner "local-exec" {
    command = <<-EOT
    xcopy .\code_commit_data\* .\${var.mybookstore-WebAssets} /Y /E /I 
    EOT

  }
  depends_on = [null_resource.Clone_Repo]
}

resource "null_resource" "git_Add" {
  provisioner "local-exec" {
    command = <<-EOT
    cd ${var.mybookstore-WebAssets} && git add . 
    EOT

  }
  depends_on = [null_resource.Copy_data_to_local_repo]
}


resource "null_resource" "git_commit" {
  provisioner "local-exec" {
    command = <<-EOT
    cd ${var.mybookstore-WebAssets} && git commit -m "Adding_data_to_code_commit"
    EOT

  }
  depends_on = [null_resource.git_Add]
}

resource "null_resource" "git_push" {
  provisioner "local-exec" {
    command = <<-EOT
    cd ${var.mybookstore-WebAssets} && git push
    EOT

  }
  depends_on = [null_resource.git_commit]
}
