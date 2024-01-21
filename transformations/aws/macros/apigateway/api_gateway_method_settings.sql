{% macro api_gateway_method_settings() %}
  {{ return(adapter.dispatch('api_gateway_method_settings')()) }}
{% endmacro %}

{% macro default__api_gateway_method_settings() %}{% endmacro %}

{% macro postgres__api_gateway_method_settings() %}
WITH apigateway_rest_api_stages AS (
  SELECT
    *,
    method_settings::text = '{}'::text AS is_empty_method_settings
  FROM aws_apigateway_rest_api_stages
)
SELECT
    s.arn,
    s.rest_api_arn,
    s.stage_name,
    s.tracing_enabled AS stage_data_trace_enabled,
    s.cache_cluster_enabled AS stage_caching_enabled,
    s.web_acl_arn AS waf,
    s.client_certificate_id AS cert,
    CASE
    WHEN s.is_empty_method_settings THEN '/*/'
    ELSE methods.key
    END as method,
    CASE
    WHEN s.is_empty_method_settings THEN false
    ELSE (methods.value::JSON -> 'DataTraceEnabled')::TEXT::BOOLEAN
    END as data_trace_enabled,
    CASE
    WHEN s.is_empty_method_settings THEN false
    ELSE (methods.value::JSON -> 'CachingEnabled')::TEXT::BOOLEAN
    END as caching_enabled,
    CASE
    WHEN s.is_empty_method_settings THEN false
    ELSE (methods.value::JSON -> 'CacheDataEncrypted')::TEXT::BOOLEAN
    END as cache_data_encrypted,
    CASE
    WHEN s.is_empty_method_settings THEN '"OFF"'
    ELSE (methods.value::JSON -> 'LoggingLevel')::TEXT
    END as logging_level,
    r.account_id
FROM
    apigateway_rest_api_stages s
JOIN
    aws_apigateway_rest_apis r ON s.rest_api_arn = r.arn
LEFT JOIN LATERAL
    JSONB_EACH_TEXT(s.method_settings) AS methods ON s.is_empty_method_settings = false
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
