
provider "aws"{
region = "us-east-1"  # Replace with your desired AWS region.
}
resource "aws_instance" "app_server" {
        ami             = "ami-0c7217cdde317cfec"
        instance_type   = "t2.micro"
        key_name        = "pradeep"
        user_data	      = file("file.sh")
        vpc_security_group_ids = [aws_security_group.main.id]
}
resource "aws_security_group" "allow_tls" {
        name        = "allow_tls"
        description = "Allow TLS inbound traffic"
        dynamic "ingress" {
        for_each = [80,22,8080]
        iterator = port
        content {
        description = "TLS from VPC"
        from_port   = port.value
        to_port     = port.value
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
}
  }
  dynamic egress {
        for_each         =[80]
        iterator         = port
        content{
        from_port        = port.value
        to_port          = port.value
        protocol         = "tcp"
        cidr_blocks      = ["0.0.0.0/0"]
        #ipv6_cidr_blocks = ["::/0"]
   }
 }
}
output "public_ip" {
        value = aws_instance.app_server.public_ip
}
#Output-2
output "private_ip" {
        value = aws_instance.app_server.private_ip
}
