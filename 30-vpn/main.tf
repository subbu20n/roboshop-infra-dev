# resource "aws_key_pair" "openvpn" {
#     key_name = "openvpn" 
#     public_key = file("c:\\devops\\daws-84s\\openvpn.pub")
# }

resource "aws_instance" "vpn" {
    ami  = local.ami_id 
    instance_type  = "t3.micro"
    vpc_security_group_ids = [local.vpn_sg_id]
    subnet_id = local.public_subnet_ids 
    key_name = "daws-84s"
    #key_name = aws_key_pair.openvpn.key_name
    user_data = file("openvpn.sh")

    tags = merge(
        local.common_tags, 
        {
            Name = "${var.project}-${var.environment}-vpn"
        }
    )
}

resource "aws_route53_record" "vpn" {
    zone_id = var.zone_id 
    name = "$vpn.${var.zone_name}"
    type  = "A" 
    ttl  = 1 
    records  = [aws_instance.vpn.public_ip] 
    allow_overwrite = true 
}