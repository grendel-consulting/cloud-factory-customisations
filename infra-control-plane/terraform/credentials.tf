data "tls_certificate" "tfc_certificate" {
  url = "https://${local.tfc_hostname}"
}

resource "aws_iam_openid_connect_provider" "tfc_provider" {
  url             = data.tls_certificate.tfc_certificate.url
  client_id_list  = [local.tfc_aws_audience]
  thumbprint_list = [data.tls_certificate.tfc_certificate.certificates[0].sha1_fingerprint]
}

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
       "Federated": "${aws_iam_openid_connect_provider.tfc_provider.arn}"
     },
     "Action": "sts:AssumeRoleWithWebIdentity",
     "Condition": {
       "StringEquals": {
         "${local.tfc_hostname}:aud": "${one(aws_iam_openid_connect_provider.tfc_provider.client_id_list)}"
       },
       "StringLike": {
         "${local.tfc_hostname}:sub": "organization:${local.tfc_organisation_name}:project:${local.tfc_project_name}:workspace:*:run_phase:*"
       }
     }
   }
 ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "tfc_role_superpowers" {
  role       = aws_iam_role.tfc_role.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}
