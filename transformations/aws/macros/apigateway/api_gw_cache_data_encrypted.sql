{% macro api_gw_cache_data_encrypted(framework, check_id) %}
  {{ return(adapter.dispatch('api_gw_cache_data_encrypted')(framework, check_id)) }}
{% endmacro %}

{% macro default__api_gw_cache_data_encrypted(framework, check_id) %}{% endmacro %}

{% macro postgres__api_gw_cache_data_encrypted(framework, check_id) %}
with bad_methods as (
	SELECT DISTINCT
		s.arn
	FROM
		aws_apigateway_rest_api_stages s,
		jsonb_each(COALESCE(s.method_settings, '{}'::jsonb)) as ms
	WHERE
		ms IS not NULL
		AND
		ms.value->>'CachingEnabled' = 'true'
		AND
		ms.value->>'CacheDataEncrypted' <> 'true'
),
cache_enabled AS (
SELECT DISTINCT
    s.arn,
    s.account_id
FROM
    aws_apigateway_rest_api_stages s,
    LATERAL jsonb_each(COALESCE(s.method_settings, '{}'::jsonb)) as ms
WHERE
    ms.value->>'CachingEnabled' = 'true'
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
        ON ce.arn = b.arn
{% endmacro %}

{% macro snowflake__api_gw_cache_data_encrypted(framework, check_id) %}
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
        ON ce.arn = b.arn
{% endmacro %}

{% macro bigquery__api_gw_cache_data_encrypted(framework, check_id) %}
with bad_methods as (
select DISTINCT
    arn
from {{ full_table_name("aws_apigateway_rest_api_stages") }} as s,
    UNNEST(JSON_QUERY_ARRAY(s.method_settings)) AS ms
  WHERE
    JSON_VALUE(ms.CachingEnabled) = 'true'
    AND
    JSON_VALUE(ms.CacheDataEncrypted) <> 'true'
),
cache_enabled AS (
select DISTINCT
    arn,
    account_id
FROM  {{ full_table_name("aws_apigateway_rest_api_stages") }} as s,
UNNEST(JSON_QUERY_ARRAY(s.method_settings)) AS ms
WHERE
    JSON_VALUE(ms.CachingEnabled) = 'true'
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
        ON ce.arn = b.arn
{% endmacro %}

{% macro athena__api_gw_cache_data_encrypted(framework, check_id) %}
select * from (
with bad_methods as (
select DISTINCT
    arn

from aws_apigateway_rest_api_stages as s,
unnest(try_cast(json_parse(s.method_settings) as array(json))) as t(ms)
  
  WHERE
    json_extract_scalar(ms, '$.CachingEnabled') = 'true'
    AND
    json_extract_scalar(ms, '$.CacheDataEncrypted') <> 'true'
),
cache_enabled AS (
select DISTINCT
    arn,
    account_id
FROM  aws_apigateway_rest_api_stages as s,
unnest(try_cast(json_parse(s.method_settings) as array(json))) as t(ms)
WHERE
    json_extract_scalar(ms, '$.CachingEnabled') = 'true'
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
        ON ce.arn = b.arn
)
{% endmacro %}