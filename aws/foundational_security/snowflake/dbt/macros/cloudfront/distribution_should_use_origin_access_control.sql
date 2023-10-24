{% macro distribution_should_use_origin_access_control(framework, check_id) %}
WITH s3_origins AS (
    SELECT DISTINCT
        arn,
        o.value:DomainName AS s3_domain_name,
        o.value:OriginAccessControlId::STRING AS origin_access_control_id
    FROM
        aws_cloudfront_distributions
    , LATERAL FLATTEN(input => COALESCE(distribution_config:Origins:Items, ARRAY_CONSTRUCT())) AS o
    WHERE
        o.value:S3OriginConfig IS NOT NULL
        AND o.value:DomainName LIKE '%.s3.%'
),
s3_origins_with_buckets AS (
SELECT DISTINCT
    s.arn,
    s.origin_access_control_id
FROM
    s3_origins s
INNER JOIN aws_s3_buckets b ON SPLIT_PART(s3_domain_name, '.', 1) = b.name
 )
  
SELECT DISTINCT
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'CloudFront distributions should use origin access control' as title,
    d.account_id,
    d.arn as resouce_id,
    CASE
        WHEN o.arn is not null 
            and (o.origin_access_control_id is null 
            or o.origin_access_control_id = '') THEN 'fail'
        ELSE 'pass'
    END as status
    
FROM aws_cloudfront_distributions as d 
LEFT JOIN s3_origins_with_buckets as o ON d.arn = o.arn
{% endmacro %}