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

{% macro bigquery__origin_access_identity_enabled(framework, check_id) %}
select
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'CloudFront distributions should have origin access identity enabled' as title,
    account_id,
    arn as resource_id,
    CASE
        WHEN CAST(JSON_VALUE(o.DomainName) AS STRING) LIKE '%s3.amazonaws.com' 
        AND CAST(JSON_VALUE(o.S3OriginConfig.OriginAccessIdentity) AS STRING) = '' THEN 'fail'
        ELSE 'pass'
    END AS status
from {{ full_table_name("aws_cloudfront_distributions") }},
UNNEST(JSON_QUERY_ARRAY(distribution_config.Origins.Items)) AS o
{% endmacro %}

{% macro athena__origin_access_identity_enabled(framework, check_id) %}
select
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'CloudFront distributions should have origin access identity enabled' as title,
    account_id,
    arn as resource_id,
    CASE
        WHEN json_extract_scalar(o, '$.DomainName') LIKE '%s3.amazonaws.com' AND json_extract_scalar(o, '$.S3OriginConfig.OriginAccessIdentity') = '' THEN 'fail'
        ELSE 'pass'
    END AS status
from aws_cloudfront_distributions,
unnest(cast(json_extract(distribution_config, '$.Origins.Items') as array(json))) as t(o)
{% endmacro %}