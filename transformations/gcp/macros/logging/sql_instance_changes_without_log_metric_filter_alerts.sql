{% macro logging_sql_instance_changes_without_log_metric_filter_alerts(framework, check_id) %}
  {{ return(adapter.dispatch('logging_sql_instance_changes_without_log_metric_filter_alerts')(framework, check_id)) }}
{% endmacro %}

{% macro default__logging_sql_instance_changes_without_log_metric_filter_alerts(framework, check_id) %}{% endmacro %}

{% macro postgres__logging_sql_instance_changes_without_log_metric_filter_alerts(framework, check_id) %}
select 
                "filter"                                                                    AS resource_id,
                '{{framework}}' As framework,
                '{{check_id}}' As check_id,                                                                         
                'Ensure that the log metric filter and alerts exist for SQL instance configuration changes (Automated)' AS title,
                project_id                                                                AS project_id,
                CASE
                WHEN
                            disabled = FALSE
                        AND "filter" = 'protoPayload.methodName="cloudsql.instances.update"'
                    THEN 'fail'
                ELSE 'pass'
                END AS status
    FROM gcp_logging_metrics
{% endmacro %}

{% macro snowflake__logging_sql_instance_changes_without_log_metric_filter_alerts(framework, check_id) %}
select 
                filter                                                                    AS resource_id,
                '{{framework}}' As framework,
                '{{check_id}}' As check_id,                                                                         
                'Ensure that the log metric filter and alerts exist for SQL instance configuration changes (Automated)' AS title,
                project_id                                                                AS project_id,
                CASE
                WHEN
                            disabled = FALSE
                        AND filter = 'protoPayload.methodName="cloudsql.instances.update"'
                    THEN 'fail'
                ELSE 'pass'
                END AS status
    FROM gcp_logging_metrics
{% endmacro %}

{% macro bigquery__logging_sql_instance_changes_without_log_metric_filter_alerts(framework, check_id) %}
select 
                filter                                                                    AS resource_id,
                '{{framework}}' As framework,
                '{{check_id}}' As check_id,                                                                         
                'Ensure that the log metric filter and alerts exist for SQL instance configuration changes (Automated)' AS title,
                project_id                                                                AS project_id,
                CASE
                WHEN
                            disabled = FALSE
                        AND filter = 'protoPayload.methodName="cloudsql.instances.update"'
                    THEN 'fail'
                ELSE 'pass'
                END AS status
FROM {{ full_table_name("gcp_logging_metrics") }}
{% endmacro %}