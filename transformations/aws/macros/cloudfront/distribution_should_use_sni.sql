{% macro distribution_should_use_sni(framework, check_id) %}
  {{ return(adapter.dispatch('distribution_should_use_sni')(framework, check_id)) }}
{% endmacro %}

{% macro default__distribution_should_use_sni(framework, check_id) %}{% endmacro %}

{% macro postgres__distribution_should_use_sni(framework, check_id) %}
select
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'CloudFront distributions should use SNI to serve HTTPS requests' as title,
    account_id,
    arn as resource_id,
    CASE 
        WHEN distribution_config -> 'ViewerCertificate' ->> 'SSLSupportMethod' <> 'sni-only'
        THEN 'fail'
        ELSE 'pass'
    END as status
from aws_cloudfront_distributions
{% endmacro %}

{% macro snowflake__distribution_should_use_sni(framework, check_id) %}
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

{% macro bigquery__distribution_should_use_sni(framework, check_id) %}
select
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'CloudFront distributions should use SNI to serve HTTPS requests' as title,
    account_id,
    arn as resource_id,
    CASE 
        WHEN JSON_VALUE(distribution_config.ViewerCertificate.SSLSupportMethod) <> 'sni-only'
        THEN 'fail'
        ELSE 'pass'
    END as status
from {{ full_table_name("aws_cloudfront_distributions") }}
{% endmacro %}

{% macro athena__distribution_should_use_sni(framework, check_id) %}
select
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'CloudFront distributions should use SNI to serve HTTPS requests' as title,
    account_id,
    arn as resource_id,
    CASE 
        WHEN json_extract_scalar(distribution_config, '$.ViewerCertificate:SSLSupportMethod') <> 'sni-only'
        THEN 'fail'
        ELSE 'pass'
    END as status
from aws_cloudfront_distributions
{% endmacro %}