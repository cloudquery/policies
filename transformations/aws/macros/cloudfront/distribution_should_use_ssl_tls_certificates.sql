{% macro distribution_should_use_ssl_tls_certificates(framework, check_id) %}
  {{ return(adapter.dispatch('distribution_should_use_ssl_tls_certificates')(framework, check_id)) }}
{% endmacro %}

{% macro default__distribution_should_use_ssl_tls_certificates(framework, check_id) %}{% endmacro %}

{% macro postgres__distribution_should_use_ssl_tls_certificates(framework, check_id) %}
select
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'CloudFront distributions should use custom SSL/TLS certificates' as title,
    account_id,
    arn as resource_id,
    CASE 
        WHEN (distribution_config -> 'ViewerCertificate' ->> 'ACMCertificateArn' is null
            AND
            distribution_config -> 'ViewerCertificate' ->> 'IAMCertificateId' is null
            ) 
            OR (distribution_config -> 'ViewerCertificate' ->> 'CloudFrontDefaultCertificate')::boolean = true
        THEN 'fail'
        ELSE 'pass'
    END as status
from aws_cloudfront_distributions
{% endmacro %}

{% macro snowflake__distribution_should_use_ssl_tls_certificates(framework, check_id) %}
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

{% macro bigquery__distribution_should_use_ssl_tls_certificates(framework, check_id) %}
select
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'CloudFront distributions should use custom SSL/TLS certificates' as title,
    account_id,
    arn as resource_id,
    CASE 
        WHEN (distribution_config.ViewerCertificate.ACMCertificateArn is null
            AND
            distribution_config.ViewerCertificate.IAMCertificateId is null
            ) 
            OR CAST( JSON_VALUE(distribution_config.ViewerCertificate.CloudFrontDefaultCertificate) AS BOOL) = true
        THEN 'fail'
        ELSE 'pass'
    END as status
from {{ full_table_name("aws_cloudfront_distributions") }}
{% endmacro %}

{% macro athena__distribution_should_use_ssl_tls_certificates(framework, check_id) %}
select
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'CloudFront distributions should use custom SSL/TLS certificates' as title,
    account_id,
    arn as resource_id,
    CASE 
        WHEN (json_extract(distribution_config, '$.ViewerCertificate:ACMCertificateArn') is null
            AND
            json_extract(distribution_config, '$.ViewerCertificate:IAMCertificateId') is null
            ) 
            OR cast(json_extract_scalar(distribution_config, '$.ViewerCertificate:CloudFrontDefaultCertificate') as boolean) = true
        THEN 'fail'
        ELSE 'pass'
    END as status
from aws_cloudfront_distributions
{% endmacro %}