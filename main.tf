provider "aws" {
    region = "us-east-1"
    
}
terraform{
    backend "s3" {
        bucket = "my-app-398002237846"
        key="myapp-state/terraform.tfstate"
        region="us-east-1"

    }
    
}
resource "aws_vpc" "my-vpc"{ 
    
    cidr_block = var.vpc_cidr_block
    tags = { 
        Name = "${var.env}-vpc"
    }
}

module "myapp-subnet" {
    source = "./modules/subnet"
    vpc_id = aws_vpc.my-vpc.id 
    subnet_cidr_block = var.subnet_cidr_block
    avil_zone = var.avil_zone
    env = var.env   
}

module "myapp-server" {
    source = "./modules/server"
    vpc_id = aws_vpc.my-vpc.id 
    my_ip = var.my_ip
    avil_zone = var.avil_zone
    env = var.env
    subnet_id = module.myapp-subnet.subnet-details.id
    instance_type =var.instance_type
    public_key_location = var.public_key_location
}

