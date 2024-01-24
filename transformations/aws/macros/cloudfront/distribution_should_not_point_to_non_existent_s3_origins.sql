{% macro distribution_should_not_point_to_non_existent_s3_origins(framework, check_id) %}
  {{ return(adapter.dispatch('distribution_should_not_point_to_non_existent_s3_origins')(framework, check_id)) }}
{% endmacro %}

{% macro default__distribution_should_not_point_to_non_existent_s3_origins(framework, check_id) %}{% endmacro %}

{% macro postgres__distribution_should_not_point_to_non_existent_s3_origins(framework, check_id) %}
WITH s3_origins AS (
    SELECT DISTINCT
        arn,
        o ->> 'DomainName' AS s3_domain_name
    FROM
        aws_cloudfront_distributions,
			JSONB_ARRAY_ELEMENTS(COALESCE(distribution_config -> 'Origins' -> 'Items', '{}')) as o  
    WHERE
        (o ->> 'S3OriginConfig' IS NOT NULL OR o ->> 'S3OriginConfig' <> 'null')
        AND o ->> 'DomainName' LIKE '%.s3.%'
),
s3_origins_no_bucket AS (
SELECT DISTINCT
    s.arn
FROM
    s3_origins s
LEFT JOIN aws_s3_buckets b ON SPLIT_PART(s3_domain_name, '.', 1) = b.name
WHERE b.name is null
 
 )
SELECT DISTINCT
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'CloudFront distributions should not point to non-existent S3 origins' as title,
    d.account_id,
    d.arn as resouce_id,
    CASE
        WHEN o.arn is null THEN 'pass'
        ELSE 'fail'
    END as status
    
FROM aws_cloudfront_distributions d 
    LEFT JOIN s3_origins_no_bucket o 
    ON d.arn = o.arn

{% endmacro %}

{% macro snowflake__distribution_should_not_point_to_non_existent_s3_origins(framework, check_id) %}
WITH s3_origins AS (
    SELECT DISTINCT
        arn,
        o.value:DomainName AS s3_domain_name
    FROM
        aws_cloudfront_distributions
    , LATERAL FLATTEN(input => COALESCE(distribution_config:Origins:Items, ARRAY_CONSTRUCT())) AS o
    WHERE
        (o.value:S3OriginConfig IS NOT NULL OR o.value:S3OriginConfig <> 'null')
        AND o.value:DomainName LIKE '%.s3.%'
),
s3_origins_no_bucket AS (
SELECT DISTINCT
    s.arn
FROM
    s3_origins s
LEFT JOIN aws_s3_buckets b ON SPLIT_PART(s3_domain_name, '.', 1) = b.name
WHERE b.name is null
 
 )
SELECT DISTINCT
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'CloudFront distributions should not point to non-existent S3 origins' as title,
    d.account_id,
    d.arn as resouce_id,
    CASE
        WHEN o.arn is null THEN 'pass'
        ELSE 'fail'
    END as status
    
FROM aws_cloudfront_distributions d 
    LEFT JOIN s3_origins_no_bucket o 
    ON d.arn = o.arn
{% endmacro %}

{% macro bigquery__distribution_should_not_point_to_non_existent_s3_origins(framework, check_id) %}
WITH s3_origins AS (
    SELECT DISTINCT
        arn,
        JSON_VALUE(o.DomainName) AS s3_domain_name
    FROM
        {{ full_table_name("aws_cloudfront_distributions") }},
UNNEST(JSON_QUERY_ARRAY(distribution_config.Origins.Items)) AS o
    WHERE
        (o.S3OriginConfig IS NOT NULL OR JSON_VALUE(o.S3OriginConfig) <> 'null')
        AND JSON_VALUE(o.DomainName) LIKE '%.s3.%'
),
s3_origins_no_bucket AS (
SELECT DISTINCT
    s.arn
FROM
    s3_origins s
LEFT JOIN {{ full_table_name("aws_s3_buckets") }}
 b ON SPLIT(s3_domain_name, '.')[OFFSET(0)] = b.name
WHERE b.name is null
 
 )
SELECT DISTINCT
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'CloudFront distributions should not point to non-existent S3 origins' as title,
    d.account_id,
    d.arn as resouce_id,
    CASE
        WHEN o.arn is null THEN 'pass'
        ELSE 'fail'
    END as status
FROM {{ full_table_name("aws_cloudfront_distributions") }} d 
LEFT JOIN s3_origins_no_bucket o 
ON d.arn = o.arn
{% endmacro %}