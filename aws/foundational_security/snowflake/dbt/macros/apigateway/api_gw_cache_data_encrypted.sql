{% macro api_gw_cache_data_encrypted(framework, check_id) %}
insert into aws_policy_results
with bad_methods as (
select DISTINCT
    arn

from aws_apigateway_rest_api_stages as s,
  LATERAL FLATTEN(input => COALESCE(s.method_settings, ARRAY_CONSTRUCT())) as ms
  
  WHERE
    ms.value:CachingEnabled = 'true'
    AND
    ms.value:CacheDataEncrypted <> 'true'
),
cache_enabled AS (
select DISTINCT
    arn,
    account_id
FROM  aws_apigateway_rest_api_stages as s,
LATERAL FLATTEN(input => COALESCE(s.method_settings, ARRAY_CONSTRUCT())) as ms
WHERE
    ms.value:CachingEnabled = 'true'
)
SELECT
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'API Gateway REST API cache data should be encrypted at rest' as title,
    ce.account_id,
    ce.arn as resource_id,
    CASE
        WHEN b.arn is not null THEN 'fail'
        ELSE 'pass'
    END as status
FROM 
    cache_enabled ce
    LEFT JOIN bad_methods as b
        ON ce.arn = b.arn; 
{% endmacro %}