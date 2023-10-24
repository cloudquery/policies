{% macro distribution_should_use_ssl_tls_certificates(framework, check_id) %}
insert into aws_policy_results
select
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'CloudFront distributions should use custom SSL/TLS certificates' as title,
    account_id,
    arn as resource_id,
    CASE 
        WHEN (distribution_config:ViewerCertificate:ACMCertificateArn is null
            AND
            distribution_config:ViewerCertificate:IAMCertificateId is null
            ) 
            OR distribution_config:ViewerCertificate:CloudFrontDefaultCertificate = true
        THEN 'fail'
        ELSE 'pass'
    END as status
from aws_cloudfront_distributions
{% endmacro %}