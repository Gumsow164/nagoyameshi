#---------------------------------
# Data Sources
#---------------------------------
data "aws_prefix_list" "s3_pl" {
  name = "com.amazonaws.ap-northeast-1.s3"
}

#---------------------------------
# Random Resources
#---------------------------------
resource "random_string" "app_key" {
  length  = 32
  special = false
  upper   = false
}
