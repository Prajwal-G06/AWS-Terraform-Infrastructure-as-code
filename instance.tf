resource "aws_instance" "my_instance" {
  ami                    = "ami-040acbfd65da0c993"
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.custom_sub.id
  key_name               = "Devops_Root1"
  vpc_security_group_ids = [aws_security_group.my_security_group.id]
  tags = {
    Name = "my-dove"
  }

  provisioner "file" {
    source      = "web.sh"
    destination = "/tmp/web.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/web.sh",
      "sudo /tmp/web.sh"
    ]
  }

  connection {
    user        = "ec2-user"
    private_key = file("Devops_Root1")
    host        = self.public_ip
  }
}


resource "aws_instance" "my_private_instance" {
  ami                    = "ami-040acbfd65da0c993"
  instance_type          = "t2.micro"
  key_name               = "Devops_Root1"
  subnet_id              = aws_subnet.private_subnet.id
  vpc_security_group_ids = [aws_security_group.my_security_group.id]

  tags = {
    Name = "MyPrivateInstance"
  }

  provisioner "file" {
    source      = "web.sh" # Replace with the path to your local file
    destination = "/tmp/web.sh"

    connection {
      type                = "ssh"
      user                = "ec2-user" # Replace with appropriate username for your AMI
      private_key         = file("Devops_Root1")
      host                = self.private_ip
      bastion_host        = aws_instance.my_instance.public_ip
      bastion_user        = "ec2-user" # Replace with appropriate username for your AMI
      bastion_private_key = file("Devops_Root1")
    }
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/web.sh",
      "sudo /tmp/web.sh"
    ]

    connection {
      type                = "ssh"
      user                = "ec2-user"
      private_key         = file("Devops_Root1")
      host                = self.private_ip
      bastion_host        = aws_instance.my_instance.public_ip
      bastion_user        = "ec2-user"
      bastion_private_key = file("Devops_Root1")
    }
  }
}

resource "aws_volume_attachment" "ebs_att" {
  device_name = "/dev/sdh"
  volume_id   = aws_ebs_volume.example.id
  instance_id = aws_instance.my_instance.id
}

resource "aws_ebs_volume" "example" {
  availability_zone = "ap-south-1a"
  size              = 1
}
