{% macro rds_cluster_event_notifications_configured(framework, check_id) %}
  {{ return(adapter.dispatch('rds_cluster_event_notifications_configured')(framework, check_id)) }}
{% endmacro %}

{% macro default__rds_cluster_event_notifications_configured(framework, check_id) %}{% endmacro %}

{% macro postgres__rds_cluster_event_notifications_configured(framework, check_id) %}
select
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'An RDS event notifications subscription should be configured for critical cluster events' as title,
    account_id,
    SOURCE_ARN AS resource_id,
    CASE 
        WHEN 
			'maintenance' = any(EVENT_CATEGORIES) 
			AND 'failure' = any(EVENT_CATEGORIES) 
            THEN 'pass'
        ELSE 'fail'
    END AS status
FROM
    aws_rds_events
WHERE source_type = 'db-cluster'
{% endmacro %}

{% macro snowflake__rds_cluster_event_notifications_configured(framework, check_id) %}
select
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'An RDS event notifications subscription should be configured for critical cluster events' as title,
    account_id,
    SOURCE_ARN AS resource_id,
    CASE 
        WHEN 
            ARRAY_CONTAINS('maintenance'::variant, EVENT_CATEGORIES) AND
            ARRAY_CONTAINS('failure'::variant, EVENT_CATEGORIES)
            THEN 'pass'
        ELSE 'fail'
    END AS status
FROM
    aws_rds_events
WHERE source_type = 'db-cluster'
{% endmacro %}

{% macro bigquery__rds_cluster_event_notifications_configured(framework, check_id) %}
select
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'An RDS event notifications subscription should be configured for critical cluster events' as title,
    account_id,
    SOURCE_ARN AS resource_id,
    CASE 
        WHEN 
            'maintenance' IN UNNEST(EVENT_CATEGORIES) AND
            'failure' IN UNNEST(EVENT_CATEGORIES)
            THEN 'pass'
        ELSE 'fail'
    END AS status
FROM
    {{ full_table_name("aws_rds_events") }}
WHERE source_type = 'db-cluster'
{% endmacro %}