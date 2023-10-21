resource "aws_key_pair" "task-key" {
  public_key = file("task-key.pub")
  key_name   = "task-key"
}