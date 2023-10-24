{% macro distribution_should_not_point_to_non_existent_s3_origins(framework, check_id) %}
insert into aws_policy_results
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