resource "aws_iam_policy" "jump_server_policy" {
  name        = "jump-server-policy"
  description = "Policy for jump server access to EKS and AWS resources"
  policy      = file("jump-server-policy.json")  # JSON file with necessary permissions
}
