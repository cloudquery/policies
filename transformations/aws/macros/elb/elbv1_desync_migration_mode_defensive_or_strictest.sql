{% macro elbv1_desync_migration_mode_defensive_or_strictest(framework, check_id) %}
  {{ return(adapter.dispatch('elbv1_desync_migration_mode_defensive_or_strictest')(framework, check_id)) }}
{% endmacro %}

{% macro default__elbv1_desync_migration_mode_defensive_or_strictest(framework, check_id) %}{% endmacro %}

{% macro postgres__elbv1_desync_migration_mode_defensive_or_strictest(framework, check_id) %}
select
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'Classic Load Balancer should be configured with defensive or strictest desync mitigation mode' as title,
    account_id,
    arn as resource_id,
    case
        WHEN aa ->> 'Value' in ('defensive', 'strictest') THEN 'pass'
        ELSE 'fail'
    END as status
FROM
    aws_elbv1_load_balancers as lb,
	JSONB_ARRAY_ELEMENTS(attributes -> 'AdditionalAttributes') AS aa
WHERE
    aa ->> 'Key' = 'elb.http.desyncmitigationmode'
{% endmacro %}

{% macro snowflake__elbv1_desync_migration_mode_defensive_or_strictest(framework, check_id) %}
select
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'Classic Load Balancer should be configured with defensive or strictest desync mitigation mode' as title,
    account_id,
    arn as resource_id,
    case
        WHEN aa.value:Value in ('defensive', 'strictest') THEN 'pass'
        ELSE 'fail'
    END as status
FROM
    aws_elbv1_load_balancers as lb,
    LATERAL FLATTEN(input => attributes:AdditionalAttributes) aa
WHERE
    aa.value:Key = 'elb.http.desyncmitigationmode'
{% endmacro %}

{% macro bigquery__elbv1_desync_migration_mode_defensive_or_strictest(framework, check_id) %}
select
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'Classic Load Balancer should be configured with defensive or strictest desync mitigation mode' as title,
    account_id,
    arn as resource_id,
    case
        WHEN JSON_VALUE(aa.Value) in ('defensive', 'strictest') THEN 'pass'
        ELSE 'fail'
    END as status
FROM
    {{ full_table_name("aws_elbv1_load_balancers") }} as lb,
    UNNEST(JSON_QUERY_ARRAY(attributes.AdditionalAttributes)) AS aa
WHERE
    JSON_VALUE(aa.Key) = 'elb.http.desyncmitigationmode'
{% endmacro %}