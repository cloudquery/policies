{% macro logging_project_ownership_changes_without_log_metric_filter_alerts(framework, check_id) %}
  {{ return(adapter.dispatch('logging_project_ownership_changes_without_log_metric_filter_alerts')(framework, check_id)) }}
{% endmacro %}

{% macro default__logging_project_ownership_changes_without_log_metric_filter_alerts(framework, check_id) %}{% endmacro %}

{% macro postgres__logging_project_ownership_changes_without_log_metric_filter_alerts(framework, check_id) %}
select DISTINCT 
                "filter"                                                                    AS resource_id,
                '{{framework}}' As framework,
                '{{check_id}}' As check_id,                                                                         
                'Ensure log metric filter and alerts exist for project ownership assignments/changes (Automated)' AS title,
                project_id                                                                AS project_id,
                CASE
                WHEN
                            disabled = FALSE
                        AND "filter" ~
                            '\s*(\s*protoPayload.serviceName\s*=\s*"cloudresourcemanager.googleapis.com"\s*)\s*AND\s*(\s*ProjectOwnership\s*OR\s*projectOwnerInvitee\s*)\s*OR\s*(\s*protoPayload.serviceData.policyDelta.bindingDeltas.action\s*=\s*"REMOVE"\s*AND\s*protoPayload.serviceData.policyDelta.bindingDeltas.role\s*=\s*"roles/owner"\s*)\s*OR\s*(\s*protoPayload.serviceData.policyDelta.bindingDeltas.action\s*=\s*"ADD"\s*AND\s*protoPayload.serviceData.policyDelta.bindingDeltas.role\s*=\s*"roles/owner"\s*)\s*'
                    THEN 'fail'
                ELSE 'pass'
                END AS status
    FROM gcp_logging_metrics
{% endmacro %}

{% macro snowflake__logging_project_ownership_changes_without_log_metric_filter_alerts(framework, check_id) %}
select DISTINCT 
                filter                                                                   AS resource_id,
                '{{framework}}' As framework,
                '{{check_id}}' As check_id,                                                                         
                'Ensure log metric filter and alerts exist for project ownership assignments/changes (Automated)' AS title,
                project_id                                                                AS project_id,
                CASE
                WHEN
                            disabled = FALSE
                        AND filter REGEXP
                            '\s*(\s*protoPayload.serviceName\s*=\s*"cloudresourcemanager.googleapis.com"\s*)\s*AND\s*(\s*ProjectOwnership\s*OR\s*projectOwnerInvitee\s*)\s*OR\s*(\s*protoPayload.serviceData.policyDelta.bindingDeltas.action\s*=\s*"REMOVE"\s*AND\s*protoPayload.serviceData.policyDelta.bindingDeltas.role\s*=\s*"roles/owner"\s*)\s*OR\s*(\s*protoPayload.serviceData.policyDelta.bindingDeltas.action\s*=\s*"ADD"\s*AND\s*protoPayload.serviceData.policyDelta.bindingDeltas.role\s*=\s*"roles/owner"\s*)\s*'
                    THEN 'fail'
                ELSE 'pass'
                END AS status
    FROM gcp_logging_metrics
{% endmacro %}

{% macro bigquery__logging_project_ownership_changes_without_log_metric_filter_alerts(framework, check_id) %}
select DISTINCT 
                filter                                                                    AS resource_id,
                '{{framework}}' As framework,
                '{{check_id}}' As check_id,                                                                         
                'Ensure log metric filter and alerts exist for project ownership assignments/changes (Automated)' AS title,
                project_id                                                                AS project_id,
                CASE
                WHEN
                            disabled = FALSE
                        AND REGEXP_CONTAINS(filter, r'\s*(\s*protoPayload.serviceName\s*=\s*"cloudresourcemanager.googleapis.com"\s*)\s*AND\s*(\s*ProjectOwnership\s*OR\s*projectOwnerInvitee\s*)\s*OR\s*(\s*protoPayload.serviceData.policyDelta.bindingDeltas.action\s*=\s*"REMOVE"\s*AND\s*protoPayload.serviceData.policyDelta.bindingDeltas.role\s*=\s*"roles/owner"\s*)\s*OR\s*(\s*protoPayload.serviceData.policyDelta.bindingDeltas.action\s*=\s*"ADD"\s*AND\s*protoPayload.serviceData.policyDelta.bindingDeltas.role\s*=\s*"roles/owner"\s*)\s*')
                THEN 'fail'
                ELSE 'pass'
                END AS status
    FROM {{ full_table_name("gcp_logging_metrics") }}
{% endmacro %}