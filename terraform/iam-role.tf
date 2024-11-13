resource "aws_iam_role" "jump_server_role" {
  name = "jump-server-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "jump_server_policy_attachment" {
  role       = aws_iam_role.jump_server_role.name
  policy_arn = aws_iam_policy.jump_server_policy.arn
}
