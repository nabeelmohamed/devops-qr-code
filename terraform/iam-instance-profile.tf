resource "aws_iam_instance_profile" "jump_instance_profile" {
  name = "jump-server-instance-profile"
  role = aws_iam_role.jump_server_role.name
}
