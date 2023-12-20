provider "aws" {
	region = "eu-west-3"
}

resource "aws_instance" "server" {
 ami           = "ami-00983e8a26e4c9bd9"
 instance_type = "t2.micro"
}

provisioner "file" {
  source      = "./app.py"
  destination = "/opt/app.py"
  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file("./id_rsa")
  }
}

provisioner "remote-exec" {
  inline = [
    "sudo yum update -y",
    "sudo apt install  -y python3",
    "python3 /opt/app.py",
  ]

  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file("./id_rsa")
    host        = aws_instance.server.public_ip
  }
}