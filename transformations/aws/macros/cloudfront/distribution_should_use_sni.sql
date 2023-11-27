{% macro distribution_should_use_sni(framework, check_id) %}
select
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'CloudFront distributions should use SNI to serve HTTPS requests' as title,
    account_id,
    arn as resource_id,
    CASE 
        WHEN distribution_config:ViewerCertificate:SSLSupportMethod <> 'sni-only'
        THEN 'fail'
        ELSE 'pass'
    END as status
from aws_cloudfront_distributions
{% endmacro %}