data "aws_iam_policy_document" "underutilized_lambda_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "underutilized_lambda_iam_role" {
  name               = "underutilized_lambda_iam_role"
  assume_role_policy = data.aws_iam_policy_document.underutilized_lambda_assume_role.json
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonEC2ReadOnlyAccess",
    "arn:aws:iam::aws:policy/AmazonRDSReadOnlyAccess",
    "arn:aws:iam::aws:policy/CloudWatchReadOnlyAccess"
  ]

  inline_policy {
    name = "underutilized_lambda_iam_role_inline_policy"
    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Effect = "Allow"
          Action = "sns:Publish",
          Resource = aws_sns_topic.underutilized_sns_topic.arn
          }
        ]
      })
    }
  }


data "archive_file" "underutilized_function_file" {
  type        = "zip"
  source_file = "${path.module}/check_underutilized.py"
  output_path = "${path.module}/check_underutilized.py.zip"
}

resource "aws_lambda_function" "underutilized_lambda" {
  filename      = "${path.module}/check_underutilized.py.zip"
  function_name = "check_underutilized"
  role          = aws_iam_role.underutilized_lambda_iam_role.arn
  handler       = "check_underutilized.lambda_handler"
  timeout = 600

  source_code_hash = data.archive_file.underutilized_function_file.output_base64sha256

  runtime = "python3.12"

}

resource "aws_lambda_function_event_invoke_config" "underutilized_lambda_event_invoke_config" {
  function_name = aws_lambda_function.underutilized_lambda.arn

  destination_config {
    on_success {
      destination = aws_sns_topic.underutilized_sns_topic.arn
    }
  }
}

data "aws_iam_policy_document" "underutilized_every_1_hour_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["scheduler.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "underutilized_every_1_hour_role" {
  name = "underutilized_every_1_hour_role"

  inline_policy {
    name = "underutilized_every_1_hour_inline_policy"
    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Action = "lambda:InvokeFunction"
          Effect = "Allow"
          Resource = [
              aws_lambda_function.underutilized_lambda.arn,
              "${aws_lambda_function.underutilized_lambda.arn}:*"
          ]
        }
      ]
    })
  }

  assume_role_policy = data.aws_iam_policy_document.underutilized_every_1_hour_role_policy.json

}


resource "aws_scheduler_schedule" "underutilized_every_1_hour" {
  state = "DISABLED"
  name       = "underutilized_every_1_hour"
  group_name = "default"

  flexible_time_window {
    mode = "OFF"
  }

  schedule_expression = "rate(5 minutes)"

  target {
    arn      = aws_lambda_function.underutilized_lambda.arn
    role_arn = aws_iam_role.underutilized_every_1_hour_role.arn
    input = jsonencode({
      days_before: 0
      hours_before: 1
      minutes_before: 0
      seconds_before: 0
      cpu_instance_threshold: 20
      cpu_rds_threshold: 20
  })
  }

}

resource "aws_sns_topic" "underutilized_sns_topic" {
  name = "underutilized_sns_topic"
}

resource "aws_sns_topic_subscription" "user_updates_sqs_target" {
  topic_arn = aws_sns_topic.underutilized_sns_topic.arn
  protocol  = "email"
  endpoint  = var.alert_mail_recvr
}
