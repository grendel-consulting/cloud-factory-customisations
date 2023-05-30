resource "aws_iam_role" "tfc_role" {
  name                  = "tfc-role"
  force_detach_policies = true

  assume_role_policy = <<EOF
{
 "Version": "2012-10-17",
 "Statement": [
   {
     "Effect": "Allow",
     "Principal": {
       "AWS": "arn:aws:iam::${data.aws_ssm_parameter.control_plane.value}:root"
     },
     "Action": "sts:AssumeRole"
   }
 ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "tfc_role_superpowers" {
  role       = aws_iam_role.tfc_role.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}
