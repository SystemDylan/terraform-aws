# Create a wildcard SSL certificate for the given domain name
resource "aws_acm_certificate" "wildcard_cert" {
  domain_name       = "*.${var.domain_name}"
  validation_method = "DNS"

  # Add tags to the certificate
  tags = {
    Terraform = "true"
  }

  # Ensure new certificate is created before the old one is destroyed
  lifecycle {
    create_before_destroy = true
  }
}

# Create Route53 DNS validation records for the wildcard certificate
resource "aws_route53_record" "wildcard_cert_validation" {
  for_each = {
    for dvo in aws_acm_certificate.wildcard_cert.domain_validation_options : dvo.domain_name => { # Use the for_each loop to iterate over the domain validation options from the ACM certificate
      name   = dvo.resource_record_name # Set the name for the DNS record based on the resource record name provided by the ACM certificate
      record = dvo.resource_record_value # Set the record value for the DNS record based on the resource record value provided by the ACM certificate
      type   = dvo.resource_record_type # Set the record type for the DNS record based on the resource record type provided by the ACM certificate
    }
  }

  name    = each.value.name # Assign the name for the Route53 DNS record from the for_each loop
  records = [each.value.record] # Assign the record value for the Route53 DNS record from the for_each loop
  ttl     = 60 # Set the time-to-live (TTL) for the Route53 DNS record to 60 seconds
  type    = each.value.type # Assign the record type for the Route53 DNS record from the for_each loop
  zone_id = var.dns_zone_id # Set the zone ID for the Route53 DNS record based on the input variable
}

# Validate the wildcard SSL certificate using the created Route53 DNS records
resource "aws_acm_certificate_validation" "wildcard_cert_validation" {
  certificate_arn         = aws_acm_certificate.wildcard_cert.arn
  validation_record_fqdns = [for record in aws_route53_record.wildcard_cert_validation : record.fqdn]
}

# Output the ARN of the validated wildcard SSL certificate
output "certificate_arn" {
  description = "The ARN of the created wildcard SSL certificate"
  value       = aws_acm_certificate_validation.wildcard_cert_validation.certificate_arn
}
