variable "mybookstore-domain" {
  type    = string
  default = "mybookstore-domain"
}


variable "AssetsBucket" {
  type    = string
  default = "mybookstore-assetsbucket-ptrp4fcz0svs1996234"
}

variable "pipelinebucket" {
  type    = string
  default = "mybookstore-pipelineartifactsbucket-hvw408u3h4cl1996234"
}

# variable "AssetsCDN" {
#   type    = string
#   default = 
# }

variable "ProjectName" {
  type    = string
  default = "mybookstore"
}

variable "account_id" {
  type    = number
  default = 819807368852
}

variable "region" {
  type    = string
  default = "us-east-1"
}

variable "mybookstore-WebAssets" {
  type    = string
  default = "mybookstore-WebAssets"

}
