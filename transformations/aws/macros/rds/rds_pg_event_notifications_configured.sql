{% macro rds_pg_event_notifications_configured(framework, check_id) %}
  {{ return(adapter.dispatch('rds_pg_event_notifications_configured')(framework, check_id)) }}
{% endmacro %}

{% macro default__rds_pg_event_notifications_configured(framework, check_id) %}{% endmacro %}

{% macro postgres__rds_pg_event_notifications_configured(framework, check_id) %}
select
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'An RDS event notifications subscription should be configured for critical database parameter group events' as title,
    account_id,
    SOURCE_ARN AS resource_id,
    CASE 
        WHEN 
			'configuration change' = any(EVENT_CATEGORIES)    
		THEN 'pass'
        ELSE 'fail'
    END AS status
FROM
    aws_rds_events
where source_type = 'db-parameter-group'
{% endmacro %}

{% macro snowflake__rds_pg_event_notifications_configured(framework, check_id) %}
select
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'An RDS event notifications subscription should be configured for critical database parameter group events' as title,
    account_id,
    SOURCE_ARN AS resource_id,
    CASE 
        WHEN 
            ARRAY_CONTAINS('configuration change'::variant, EVENT_CATEGORIES) THEN 'pass'
        ELSE 'fail'
    END AS status
FROM
    aws_rds_events
where source_type = 'db-parameter-group'
{% endmacro %}

{% macro bigquery__rds_pg_event_notifications_configured(framework, check_id) %}
select
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'An RDS event notifications subscription should be configured for critical database parameter group events' as title,
    account_id,
    SOURCE_ARN AS resource_id,
    CASE 
        WHEN 
            'configuration change' IN UNNEST(EVENT_CATEGORIES) THEN 'pass'
        ELSE 'fail'
    END AS status
FROM
    {{ full_table_name("aws_rds_events") }}
where source_type = 'db-parameter-group'
{% endmacro %}