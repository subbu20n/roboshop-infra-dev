variable "project" {
    default = "roboshop" 
}

variable "environment" {
    default = "dev" 
}

variable "frontend_sg_name" {
    default = "frontend" 
}

variable "sg_description" {
    default = "created sg for frontend instance" 
} 

variable "bastion_sg_name" {
    default = "bastion" 
}

variable "bastion_sg_description" {
    default = "created sg for bastion"
}

variable "sg_tags" {
    default = {
        Name = "frontend"
    }
}
   