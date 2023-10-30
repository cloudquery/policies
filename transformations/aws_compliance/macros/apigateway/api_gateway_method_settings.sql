{% macro api_gateway_method_settings() %}
  {{ return(adapter.dispatch('api_gateway_method_settings')()) }}
{% endmacro %}

{% macro default__api_gateway_method_settings() %}{% endmacro %}

{% macro postgres__api_gateway_method_settings() %}
select
    s.arn,
    s.rest_api_arn,
    s.stage_name,
    s.tracing_enabled as stage_data_trace_enabled,
    s.cache_cluster_enabled as stage_caching_enabled,
    s.web_acl_arn as waf,
    s.client_certificate_id as cert,
    key as method,
    (
        value::JSON -> 'DataTraceEnabled'
    )::TEXT::BOOLEAN as data_trace_enabled,
    (value::JSON -> 'CachingEnabled')::TEXT::BOOLEAN as caching_enabled,
    (
        value::JSON -> 'CacheDataEncrypted'
    )::TEXT::BOOLEAN as cache_data_encrypted,
    (value::JSON -> 'LoggingLevel')::TEXT as logging_level,
    r.account_id
from aws_apigateway_rest_api_stages s, aws_apigateway_rest_apis r,
    JSONB_EACH_TEXT(s.method_settings)
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
