{% macro logging_audit_config_changes_without_log_metric_filter_alerts(framework, check_id) %}
  {{ return(adapter.dispatch('logging_audit_config_changes_without_log_metric_filter_alerts')(framework, check_id)) }}
{% endmacro %}

{% macro default__logging_audit_config_changes_without_log_metric_filter_alerts(framework, check_id) %}{% endmacro %}

{% macro postgres__logging_audit_config_changes_without_log_metric_filter_alerts(framework, check_id) %}
select 
                "filter"                                                                    AS resource_id,
                '{{framework}}' As framework,
                '{{check_id}}' As check_id,                                                                         
                'Ensure that the log metric filter and alerts exist for Audit Configuration changes (Automated)' AS title,
                project_id                                                                AS project_id,
                CASE
                WHEN
                            disabled = FALSE
                        AND "filter" ~
                            '\s*protoPayload.methodName\s*=\s*"SetIamPolicy"\s*AND\s*protoPayload.serviceData.policyDelta.auditConfigDeltas:*\s*'
                    THEN 'fail'
                ELSE 'pass'
                END AS status
    FROM gcp_logging_metrics
{% endmacro %}

{% macro snowflake__logging_audit_config_changes_without_log_metric_filter_alerts(framework, check_id) %}
select 
                filter                                                                    AS resource_id,
                '{{framework}}' As framework,
                '{{check_id}}' As check_id,                                                                         
                'Ensure that the log metric filter and alerts exist for Audit Configuration changes (Automated)' AS title,
                project_id                                                                AS project_id,
                CASE
                WHEN
                            disabled = FALSE
                        AND filter REGEXP
                            '\s*protoPayload.methodName\s*=\s*"SetIamPolicy"\s*AND\s*protoPayload.serviceData.policyDelta.auditConfigDeltas:*\s*'
                    THEN 'fail'
                ELSE 'pass'
                END AS status
    FROM gcp_logging_metrics
{% endmacro %}

{% macro bigquery__logging_audit_config_changes_without_log_metric_filter_alerts(framework, check_id) %}
select DISTINCT 
                filter                                                                    AS resource_id,
                '{{framework}}' As framework,
                '{{check_id}}' As check_id,                                                                         
                'Ensure that the log metric filter and alerts exist for Audit Configuration changes (Automated)' AS title,
                project_id                                                                AS project_id,
                CASE
                WHEN
                            disabled = FALSE
                        AND REGEXP_CONTAINS(filter, r'\s*protoPayload.methodName\s*=\s*"SetIamPolicy"\s*AND\s*protoPayload.serviceData.policyDelta.auditConfigDeltas:*\s*')
                THEN 'fail'
                ELSE 'pass'
                END AS status
    FROM {{ full_table_name("gcp_logging_metrics") }}
{% endmacro %}