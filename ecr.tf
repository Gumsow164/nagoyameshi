resource "aws_ecr_repository" "app" {
  name                 = "${var.project}-${var.enviroment}-app-repo"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name        = "${var.project}-${var.enviroment}-app-repo"
    Project     = var.project
    Environment = var.enviroment
  }
}
