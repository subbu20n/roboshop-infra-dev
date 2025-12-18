module "backend_alb" {
    source = "terraform-aws-modules/alb/aws" 
    version = "9.16.0" 
    internal =true  #it access only inside the  vpc - it cannot access from the internet  
    name = "${var.project}-${var.environment}-backend-alb" 
    vpc_id = local.vpc_id 
    subnets = local.private_subnet_ids 
    create_security_group = false 
    security_groups = [local.backend_alb_sg_id] 

    tags = merge(
        local.common_tags,
        {
            Name = "${var.project}-${var.environment}-backend-alb"
        }
    ) 
} 


resource "aws_listener_rule" "backend_alb" {
    load_balancer_arn = module.backend_alb.arn 
    port = "80" 
    protocol = "HTTP" 

    default-action {
        type = "fixed_response"

        fixed_response {
            content_type = "text/html" 
            message_body = "<h1>Hello, Hi i am from backend alb</h1>" 
            status_code = "200-299"
        }
    }
}


resource "aws_route53_record" "backend_alb" {
    zone_id = var.zone_id 
    type = "A" 
    name = "*.backend-dev.${var.zone_name}" 

    alias {
        name = module.backend_alb.dns_name 
        zone_id = module.backend_alb.zone_id  
        evaluate_target_health = true 
    }
}