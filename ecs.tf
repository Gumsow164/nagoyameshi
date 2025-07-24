resource "aws_ecs_cluster" "dev_cluster" {
  name = "dev-ecs-cluster"
}

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
