{% macro distribution_should_not_use_depricated_ssl_protocols(framework, check_id) %}
  {{ return(adapter.dispatch('distribution_should_not_use_depricated_ssl_protocols')(framework, check_id)) }}
{% endmacro %}

{% macro default__distribution_should_not_use_depricated_ssl_protocols(framework, check_id) %}{% endmacro %}

{% macro postgres__distribution_should_not_use_depricated_ssl_protocols(framework, check_id) %}
WITH origins_with_sslv3 AS (
SELECT DISTINCT
    arn,
    o ->> Id AS origin_id
FROM
    aws_cloudfront_distributions,
	JSONB_ARRAY_ELEMENTS(COALESCE(distribution_config -> 'Origins' -> 'Items', '{}')) as o  
WHERE
	o -> 'CustomOriginConfig' -> 'OriginSslProtocols' -> 'Items' ? 'SSLv3'
)

SELECT
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'CloudFront distributions should not use deprecated SSL protocols between edge locations and custom origins' as title,
    d.arn as resource_id,
    d.account_id,
    CASE
        WHEN o.arn is null THEN 'pass'
        ELSE 'fail'
    END as status
FROM
    aws_cloudfront_distributions d
    LEFT JOIN origins_with_sslv3 o
    ON d.arn = o.arn
{% endmacro %}

{% macro snowflake__distribution_should_not_use_depricated_ssl_protocols(framework, check_id) %}
WITH origins_with_sslv3 AS (
SELECT DISTINCT
    arn,
    o.value:Id AS origin_id
FROM
    aws_cloudfront_distributions
, LATERAL FLATTEN(input => COALESCE(distribution_config:Origins:Items, ARRAY_CONSTRUCT())) AS o
WHERE
    ARRAY_CONTAINS('SSLv3'::variant, o.value:CustomOriginConfig:OriginSslProtocols:Items::ARRAY)
)

SELECT
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'CloudFront distributions should not use deprecated SSL protocols between edge locations and custom origins' as title,
    d.arn as resource_id,
    d.account_id,
    CASE
        WHEN o.arn is null THEN 'pass'
        ELSE 'fail'
    END as status
FROM
    aws_cloudfront_distributions d
    LEFT JOIN origins_with_sslv3 o
    ON d.arn = o.arn
{% endmacro %}

{% macro bigquery__distribution_should_not_use_depricated_ssl_protocols(framework, check_id) %}
WITH origins_with_sslv3 AS (
SELECT DISTINCT
    arn,
    JSON_VALUE(o.Id) AS origin_id
FROM
    {{ full_table_name("aws_cloudfront_distributions") }},
    UNNEST(JSON_QUERY_ARRAY(distribution_config.Origins.Items)) AS o
WHERE
    'SSLv3' IN UNNEST(JSON_EXTRACT_STRING_ARRAY(o.CustomOriginConfig.OriginSslProtocols.Items))
)
SELECT
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'CloudFront distributions should not use deprecated SSL protocols between edge locations and custom origins' as title,
    d.arn as resource_id,
    d.account_id,
    CASE
        WHEN o.arn is null THEN 'pass'
        ELSE 'fail'
    END as status
FROM
            {{ full_table_name("aws_cloudfront_distributions") }} d
    LEFT JOIN origins_with_sslv3 o
    ON d.arn = o.arn
{% endmacro %}

{% macro athena__distribution_should_not_use_depricated_ssl_protocols(framework, check_id) %}
select * from (
WITH origins_with_sslv3 AS (
SELECT DISTINCT
    arn,
    json_extract_scalar(o, '$.Id') AS origin_id
FROM
    aws_cloudfront_distributions
, unnest(cast(json_extract(distribution_config, '$.Origins.Items') as array(varchar))) AS o
WHERE
    CONTAINS(cast(json_extract(o, '$.CustomOriginConfig.OriginSslProtocols.Items') as array(varchar)), 'SSLv3')
)

SELECT
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'CloudFront distributions should not use deprecated SSL protocols between edge locations and custom origins' as title,
    d.arn as resource_id,
    d.account_id,
    CASE
        WHEN o.arn is null THEN 'pass'
        ELSE 'fail'
    END as status
FROM
    aws_cloudfront_distributions d
    LEFT JOIN origins_with_sslv3 o
    ON d.arn = o.arn
)
{% endmacro %}