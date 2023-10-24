{% macro origin_access_identity_enabled(framework, check_id) %}
insert into aws_policy_results
select
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'CloudFront distributions should have origin access identity enabled' as title,
    account_id,
    arn as resource_id,
    CASE
        WHEN o.value:DomainName::STRING LIKE '%s3.amazonaws.com' AND o.value:S3OriginConfig:OriginAccessIdentity::STRING = '' THEN 'fail'
        ELSE 'pass'
    END AS status
from aws_cloudfront_distributions, LATERAL FLATTEN(input => distribution_config:Origins:Items) o
{% endmacro %}