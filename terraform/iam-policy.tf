resource "aws_iam_policy" "jump_server_policy" {
  name        = "jump-server-policy"
  description = "Policy for jump server access to EKS and AWS resources"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement: [
      {
        Effect = "Allow",
        Action: [
          "eks:*",
          "ec2:Describe*",
          "s3:*"
        ],
        Resource: "*"
      }
    ]
  })
}
