resource "aws_security_group" "myapp-sg"{
    name ="my-app-sg"
    vpc_id=var.vpc_id
    ingress {
        from_port = 22
        to_port = 22
        protocol="tcp"
        cidr_blocks=[var.my_ip]
    }
    ingress {
        from_port = 8080
        to_port = 8080
        protocol="tcp"
        cidr_blocks=["0.0.0.0/0"] 
    }
    egress {
        from_port=0
        to_port=0
        protocol="-1"
        cidr_blocks=["0.0.0.0/0"]
        prefix_list_ids=[]
    }
tags= {
        Name = "${var.env}-my-app-sg"
    } 
}

#fetch the ami
data "aws_ami" "amazon-linux-image"{
    most_recent= true    
    owners= ["amazon"]
    filter {
        name= "name"  
        values =["amzn2-ami-*x86_64-gp2"]  

    }
    filter {
        name= "virtualization-type"
        values =["hvm"]

    }
}

#creating ec2
resource "aws_instance" "myapp-server"{
    ami=data.aws_ami.amazon-linux-image.id 
    instance_type= var.instance_type 
    subnet_id=var.subnet_id
    vpc_security_group_ids= [aws_security_group.myapp-sg.id] 
    availability_zone= var.avil_zone
    associate_public_ip_address= true 
    key_name =aws_key_pair.ssh-key.key_name
    user_data = file("userdata.sh")
    tags= {
        Name = "${var.env}-server"
    } 

}
resource "aws_key_pair" "ssh-key"{
    key_name= "terraform-key"
    public_key =file(var.public_key_location) 
    
}