resource "aws_ecs_cluster" "dev_cluster" {
  name = "dev-ecs-cluster"
}

#---------------------------------
# Laravel Application Task Definition
#---------------------------------
resource "aws_ecs_task_definition" "laravel_app_task" {
  family                   = "laravel-app-task"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "512"
  memory                   = "1024"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([
    {
      name  = "laravel-app"
      image = "${aws_ecr_repository.app.repository_url}:latest"
      portMappings = [
        {
          containerPort = 80
          protocol      = "tcp"
        }
      ]
      environment = [
        {
          name  = "DB_HOST"
          value = aws_db_instance.mysql.address
        },
        {
          name  = "DB_USERNAME"
          value = var.db_username
        },
        {
          name  = "DB_PASSWORD"
          value = var.db_password
        },
        {
          name = "DB_DATABASE"
          value = aws_db_instance.mysql.db_name
        },
        {
          name  = "APP_ENV"
          value = "production"
        },
        {
          name  = "APP_DEBUG"
          value = "false"
        }
      ]
      essential = true
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = "/ecs/laravel-app"
          awslogs-region        = var.aws_region
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])

  tags = {
    Name        = "${var.project}-${var.enviroment}-laravel-app-task"
    Project     = var.project
    Environment = var.enviroment
  }
}

#---------------------------------
# Laravel Application Service
#---------------------------------
resource "aws_ecs_service" "laravel_app_service" {
  name            = "laravel-app-service"
  cluster         = aws_ecs_cluster.dev_cluster.id
  task_definition = aws_ecs_task_definition.laravel_app_task.arn
  desired_count   = 2
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = [aws_subnet.private_subnet_1a.id, aws_subnet.private_subnet_1c.id]
    security_groups  = [aws_security_group.app_sg.id]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.laravel_tg.arn
    container_name   = "laravel-app"
    container_port   = 80
  }

  depends_on = [aws_iam_role_policy_attachment.ecs_execution_policy]

  tags = {
    Name        = "${var.project}-${var.enviroment}-laravel-app-service"
    Project     = var.project
    Environment = var.enviroment
  }
}

#---------------------------------
# CloudWatch Log Group for Laravel App
#---------------------------------
resource "aws_cloudwatch_log_group" "laravel_app_logs" {
  name              = "/ecs/laravel-app"
  retention_in_days = 7

  tags = {
    Name        = "${var.project}-${var.enviroment}-laravel-app-logs"
    Project     = var.project
    Environment = var.enviroment
  }
}

#---------------------------------
# MySQL Client Task Definition (Existing)
#---------------------------------
resource "aws_ecs_task_definition" "mysql_client_task" {
  family                   = "mysql-client-task"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([
    {
      name  = "mysql-client"
      image = "mysql:8.0"
      command = [
        "sh", "-c", "sleep 3600"
      ]
      environment = [
        {
          name  = "DB_HOST"
          value = aws_db_instance.mysql.address
        },
        {
          name  = "DB_USERNAME"
          value = var.db_username
        },
        {
          name  = "DB_PASSWORD"
          value = var.db_password
        },
        {
          name = "DB_DATABASE"
          value = aws_db_instance.mysql.db_name
        }
      ]
      essential = true
    }
  ])
}

resource "aws_ecs_service" "mysql_client_service" {
  name            = "mysql-client-service"
  cluster         = aws_ecs_cluster.dev_cluster.id
  task_definition = aws_ecs_task_definition.mysql_client_task.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = [aws_subnet.private_subnet_1a.id, aws_subnet.private_subnet_1c.id]
    security_groups  = [aws_security_group.app_sg.id]
    assign_public_ip = false
  }

  depends_on = [aws_iam_role_policy_attachment.ecs_execution_policy]
}
