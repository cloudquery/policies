{% macro api_gateway_method_settings() %}
  {{ return(adapter.dispatch('api_gateway_method_settings')()) }}
{% endmacro %}

{% macro default__api_gateway_method_settings() %}{% endmacro %}

{% macro postgres__api_gateway_method_settings() %}
with apigateway_rest_api_stages as(
  select
    *,
    method_settings::text = '{}'::text as is_empty_method_settings
  from aws_apigateway_rest_api_stages
)
select
     s.arn,
     s.rest_api_arn,
	 s.stage_name,
	 s.tracing_enabled as stage_data_trace_enabled,
     s.cache_cluster_enabled as stage_caching_enabled,
     s.web_acl_arn as waf,
     s.client_certificate_id as cert,
case when (s.is_empty_method_settings = false)
        then (select key from JSONB_EACH_TEXT(s.method_settings))
        else '/*/'
    end as method,
    case when (s.is_empty_method_settings = false)
        then (select (value::JSON -> 'DataTraceEnabled')::TEXT::BOOLEAN from JSONB_EACH_TEXT(s.method_settings))
        else false
    end as data_trace_enabled,
    case when (s.is_empty_method_settings = false)
        then (select (value::JSON -> 'CachingEnabled')::TEXT::BOOLEAN from JSONB_EACH_TEXT(s.method_settings))
        else false
    end as caching_enabled,
    case when (s.is_empty_method_settings = false)
        then (select (value::JSON -> 'CacheDataEncrypted')::TEXT::BOOLEAN from JSONB_EACH_TEXT(s.method_settings))
        else false
    end as cache_data_encrypted,
    case when (s.is_empty_method_settings = false)
        then (select (value::JSON -> 'LoggingLevel')::TEXT from JSONB_EACH_TEXT(s.method_settings))
        else '"OFF"'
   end as logging_level,
     r.account_id

from apigateway_rest_api_stages s, aws_apigateway_rest_apis r
 where s.rest_api_arn=r.arn

{% endmacro %}


{% macro snowflake__api_gateway_method_settings() %}
SELECT
    s.arn,
    s.rest_api_arn,
    s.stage_name,
    s.tracing_enabled AS stage_data_trace_enabled,
    s.cache_cluster_enabled AS stage_caching_enabled,
    s.web_acl_arn AS waf,
    s.client_certificate_id AS cert,
    key AS method,
    CASE WHEN PARSE_JSON(value):DataTraceEnabled::STRING = 'true' THEN 1 ELSE 0 END AS data_trace_enabled,
    CASE WHEN PARSE_JSON(value):CachingEnabled::STRING = 'true' THEN 1 ELSE 0 END AS caching_enabled,
    CASE WHEN PARSE_JSON(value):CacheDataEncrypted::STRING = 'true' THEN 1 ELSE 0 END AS cache_data_encrypted,
    PARSE_JSON(value):LoggingLevel::STRING AS logging_level,
    r.account_id
FROM aws_apigateway_rest_api_stages s
JOIN aws_apigateway_rest_apis r ON s.rest_api_arn=r.arn,
LATERAL FLATTEN(input=>PARSE_JSON(s.method_settings))

{% endmacro %}
