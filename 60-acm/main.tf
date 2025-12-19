resource "aws_acm_certificate" "subbuaws" {
    domain_name = "dev.${var.zone_name}"
    validation_method = "DNS"

    tags =merge(
        local.common_tags,
        {
            Name = "${var.project}-${var.environment}"
        }

    )
    lifecycle{
        create_before_destroy = true 
    }
}

resource "aws_route53_record" "subbuaws" {
    for_each = {
        for dvo in aws_acm_certificate.subbuaws.domain_validation_options : dvo.domain_name => {
            name = dvo.resource_record_name 
            record = dvo.resource_record_value  
            type = dvo.resource_record_type
        }
    }
    allow_overwrite = true 
    name  = each.value.name 
    type  = each.value.type  #certificate create chesetappudu lopale chestam  record ni 
    ttl  = 60 
    records = [each.value.record]
    zone_id = var.zone_id 
}

resource "aws_acm_certificate_validation" "subbuaws" {
    certificate_arn = aws_acm_certificate.subbuaws.arn 
    validation_record_fqdns = [for record in aws_route53_record.subbuaws : record.fqdn]
}
 