resource "aws_instance" "instance" {
  for_each               = var.components
  ami                    = data.aws_ami.centos.image_id
  instance_type          = each.value["instance_type"]
  vpc_security_group_ids = [data.aws_security_group.allow-all.id]

  tags = {
    Name = each.value["name"]
  }

  provisioner "remote-exec" {

    connection {
      type     = "ssh"
      user     = "centos"
      password = "DevOps321"
      host     = self.private_ip
    }

    inline = [
      "rm-rf roboshop-shell",
      "git clone https://github.com/Nag183/roboshop-shell",
      "cd roboshop-shell",
      "sudo bash ${each.value["name"]}.sh"
    ]
  }
}


resource "aws_route53_record" "frontend" {
  for_each = var.components
  zone_id  = "Z013923922XABW4K0OEK0"
  name     = "${each.value["name"]}.dev.naginfo.us"
  type     = "A"
  ttl      = 30
  records  = [aws_instance.instance[each.value["name"]].private_ip]
}

