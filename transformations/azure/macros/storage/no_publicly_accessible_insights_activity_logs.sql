{% macro storage_no_publicly_accessible_insights_activity_logs(framework, check_id) %}
  {{ return(adapter.dispatch('storage_no_publicly_accessible_insights_activity_logs')(framework, check_id)) }}
{% endmacro %}

{% macro default__storage_no_publicly_accessible_insights_activity_logs(framework, check_id) %}{% endmacro %}

{% macro postgres__storage_no_publicly_accessible_insights_activity_logs(framework, check_id) %}
SELECT
    id                                                                                  AS resource_id,
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'Ensure the storage container storing the activity logs is not publicly accessible' AS title,
    subscription_id                                                                     AS subscription_id,
    CASE
        WHEN properties->>'publicAccess' = 'None'
        THEN 'pass'
        ELSE 'fail'
    END                                                                                 AS status
FROM azure_storage_containers
WHERE
    name = 'insights-activity-logs'
{% endmacro %}

{% macro snowflake__storage_no_publicly_accessible_insights_activity_logs(framework, check_id) %}
SELECT
    id                                                                                  AS resource_id,
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'Ensure the storage container storing the activity logs is not publicly accessible' AS title,
    subscription_id                                                                     AS subscription_id,
    CASE
        WHEN properties:publicAccess = 'None'
        THEN 'pass'
        ELSE 'fail'
    END                                                                                 AS status
FROM azure_storage_containers
WHERE
    name = 'insights-activity-logs'

{% endmacro %}