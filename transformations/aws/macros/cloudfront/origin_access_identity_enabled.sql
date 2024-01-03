{% macro origin_access_identity_enabled(framework, check_id) %}
  {{ return(adapter.dispatch('origin_access_identity_enabled')(framework, check_id)) }}
{% endmacro %}

{% macro default__origin_access_identity_enabled(framework, check_id) %}{% endmacro %}

{% macro postgres__origin_access_identity_enabled(framework, check_id) %}
select
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'CloudFront distributions should have origin access identity enabled' as title,
    account_id,
    arn as resource_id,
    CASE
        WHEN o ->> 'DomainName' LIKE '%s3.amazonaws.com' AND o -> 'S3OriginConfig' ->> 'OriginAccessIdentity' = '' THEN 'fail'
        ELSE 'pass'
    END AS status
from aws_cloudfront_distributions,
JSONB_ARRAY_ELEMENTS(distribution_config->'Origins'->'Items') as o
{% endmacro %}

{% macro snowflake__origin_access_identity_enabled(framework, check_id) %}
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