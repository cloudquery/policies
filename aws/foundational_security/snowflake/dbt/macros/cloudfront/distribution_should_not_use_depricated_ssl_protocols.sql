{% macro distribution_should_not_use_depricated_ssl_protocols(framework, check_id) %}
insert into aws_policy_results
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