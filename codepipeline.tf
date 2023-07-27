

resource "aws_codepipeline" "CodePipelinePipeline" {
  name     = "mybookstore-Assets-Pipeline"
  role_arn = aws_iam_role.mybookstore-CodePipeline-Role.arn
  artifact_store {
    location = aws_s3_bucket.S3Bucket2.id
    type     = "S3"
  }
  stage {
    name = "Source"
    action {
      name     = "Source"
      category = "Source"
      owner    = "AWS"
      configuration = {
        BranchName     = "master"
        RepositoryName = "mybookstore-WebAssets"
      }
      provider = "CodeCommit"
      version  = "1"
      output_artifacts = [
        "mybookstore-SourceArtifact"
      ]
      run_order = 1
    }

  }
  stage {
    name = "Build"
    action {
      name     = "build-and-deploy"
      category = "Build"
      owner    = "AWS"
      configuration = {
        ProjectName = "mybookstore-build"
      }
      input_artifacts = [
        "mybookstore-SourceArtifact"
      ]
      provider = "CodeBuild"
      version  = "1"
      output_artifacts = [
        "mybookstore-BuildArtifact"
      ]
      run_order = 1
    }

  }
}

