data "aws_security_group" "allow-all" {
  name = "allow-all"
}


variable "instance_type" {
  default = "t3.small"
}


variable "components" {
  default = ["frontend","mongodb","catalogue"]
}

resource "aws_instance" "instance" {
  ami           = "ami-0b5a2b5b8f2be4ec2"
  count = length(var.components)
  instance_type = var.instance_type
  vpc_security_group_ids = [data.aws_security_group.allow-all.id]

  tags = {
    Name = var.components[count.index]
  }
}

variable "records" {
  default = ["frontend-dev.pavan345.online","mongodb-dev.pavan345.online","catalogue-dev.pavan345.online"]
}

resource "aws_route53_record" "dns_records" {
  count =length(var.records)
  zone_id = "Z08045122E2EQN1OR1WS6"
  name    = var.records[count.index]
  type    = "A"
  ttl     = 30
  records = [aws_instance.instance[count.index].private_ip]
}
