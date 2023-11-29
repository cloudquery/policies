{% macro logging_custom_role_changes_without_log_metric_filter_alerts(framework, check_id) %}
  {{ return(adapter.dispatch('logging_custom_role_changes_without_log_metric_filter_alerts')(framework, check_id)) }}
{% endmacro %}

{% macro default__logging_custom_role_changes_without_log_metric_filter_alerts(framework, check_id) %}{% endmacro %}

{% macro postgres__logging_custom_role_changes_without_log_metric_filter_alerts(framework, check_id) %}
    select 
                "filter"                                                                    AS resource_id,
                _cq_sync_time As sync_time,
                '{{framework}}' As framework,
                '{{check_id}}' As check_id,                                                                         
                'Ensure that the log metric filter and alerts exist for Custom Role changes (Automated)' AS title,
                project_id                                                                AS project_id,
                CASE
                WHEN
                            disabled = FALSE
                        AND "filter" ~
                            '\s*resource.type\s*=\s*"iam_role"\s*AND\s*protoPayload.methodName\s*=\s*"google.iam.admin.v1.CreateRole"\s*OR\s*protoPayload.methodName\s*=\s*"google.iam.admin.v1.DeleteRole"\s*OR\s*protoPayload.methodName\s*=\s*"google.iam.admin.v1.UpdateRole"\s*'
                    THEN 'fail'
                ELSE 'pass'
                END AS status
    FROM gcp_logging_metrics
{% endmacro %}

{% macro snowflake__logging_custom_role_changes_without_log_metric_filter_alerts(framework, check_id) %}
 select 
                filter                                                                    AS resource_id,
                _cq_sync_time As sync_time,
                '{{framework}}' As framework,
                '{{check_id}}' As check_id,                                                                         
                'Ensure that the log metric filter and alerts exist for Custom Role changes (Automated)' AS title,
                project_id                                                                AS project_id,
                CASE
                WHEN
                            disabled = FALSE
                        AND filter REGEXP
                            '\s*resource.type\s*=\s*"iam_role"\s*AND\s*protoPayload.methodName\s*=\s*"google.iam.admin.v1.CreateRole"\s*OR\s*protoPayload.methodName\s*=\s*"google.iam.admin.v1.DeleteRole"\s*OR\s*protoPayload.methodName\s*=\s*"google.iam.admin.v1.UpdateRole"\s*'
                    THEN 'fail'
                ELSE 'pass'
                END AS status
    FROM gcp_logging_metrics
{% endmacro %}

{% macro bigquery__logging_custom_role_changes_without_log_metric_filter_alerts(framework, check_id) %}
select DISTINCT 
                filter                                                                    AS resource_id,
                _cq_sync_time As sync_time,
                '{{framework}}' As framework,
                '{{check_id}}' As check_id,                                                                         
                'Ensure that the log metric filter and alerts exist for Custom Role changes (Automated)' AS title,
                project_id                                                                AS project_id,
                CASE
                WHEN
                            disabled = FALSE
                        AND REGEXP_CONTAINS(filter, r'\s*resource.type\s*=\s*"iam_role"\s*AND\s*protoPayload.methodName\s*=\s*"google.iam.admin.v1.CreateRole"\s*OR\s*protoPayload.methodName\s*=\s*"google.iam.admin.v1.DeleteRole"\s*OR\s*protoPayload.methodName\s*=\s*"google.iam.admin.v1.UpdateRole"\s*')
                THEN 'fail'
                ELSE 'pass'
                END AS status
    FROM {{ full_table_name("gcp_logging_metrics") }}
{% endmacro %}