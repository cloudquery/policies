{% macro cloudtrail_enabled(framework, check_id) %}
  {{ return(adapter.dispatch('cloudtrail_enabled')(framework, check_id)) }}
{% endmacro %}

{% macro default__cloudtrail_enabled(framework, check_id) %}{% endmacro %}

{% macro postgres__cloudtrail_enabled(framework, check_id) %}
select
    '{{framework}}' as framework,
    '{{check_id}}' as check_id,
    'At least one CloudTrail trail should be enabled' as title,
    account_id,
    account_id as resource_id,
    CASE 
        WHEN COUNT(*) > 0 THEN 'Pass'
        ELSE 'Fail'
    END AS status
FROM aws_cloudtrail_trails
WHERE status->>'IsLogging' = 'true'
GROUP by account_id
{% endmacro %}

{% macro bigquery__cloudtrail_enabled(framework, check_id) %}
select
    '{{framework}}' as framework,
    '{{check_id}}' as check_id,
    'At least one CloudTrail trail should be enabled' as title,
    account_id,
    account_id as resource_id,
    CASE 
        WHEN COUNT(*) > 0 THEN 'Pass'
        ELSE 'Fail'
    END AS status
FROM {{ full_table_name("aws_cloudtrail_trails") }}
WHERE CAST(JSON_VALUE(status.IsLogging) AS STRING) = 'true'
GROUP by account_id
{% endmacro %}

{% macro snowflake__cloudtrail_enabled(framework, check_id) %}
select
    '{{framework}}' as framework,
    '{{check_id}}' as check_id,
    'At least one CloudTrail trail should be enabled' as title,
    account_id,
    account_id as resource_id,
    CASE 
        WHEN COUNT(*) > 0 THEN 'Pass'
        ELSE 'Fail'
    END AS status
FROM aws_cloudtrail_trails
WHERE status:IsLogging = 'true'
GROUP by account_id
{% endmacro %}

{% macro athena__cloudtrail_enabled(framework, check_id) %}
select
    '{{framework}}' as framework,
    '{{check_id}}' as check_id,
    'At least one CloudTrail trail should be enabled' as title,
    account_id,
    account_id as resource_id,
    CASE 
        WHEN COUNT(*) > 0 THEN 'Pass'
        ELSE 'Fail'
    END AS status
FROM aws_cloudtrail_trails
WHERE cast(json_extract(status, '$.IsLogging') as varchar) = 'true'
GROUP by account_id
{% endmacro %}