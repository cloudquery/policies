{% macro logging_vpc_route_changes_without_log_metric_filter_alerts(framework, check_id) %}
  {{ return(adapter.dispatch('logging_vpc_route_changes_without_log_metric_filter_alerts')(framework, check_id)) }}
{% endmacro %}

{% macro default__logging_vpc_route_changes_without_log_metric_filter_alerts(framework, check_id) %}{% endmacro %}

{% macro postgres__logging_vpc_route_changes_without_log_metric_filter_alerts(framework, check_id) %}
    select 
                "filter"                                                                    AS resource_id,
                '{{framework}}' As framework,
                '{{check_id}}' As check_id,                                                                         
                'Ensure that the log metric filter and alerts exist for VPC network route changes (Automated)' AS title,
                project_id                                                                AS project_id,
                CASE
                WHEN
                            disabled = FALSE
                        AND "filter" ~
                            '\s*resource.type\s*=\s*"gce_route"\s*AND\s*protoPayload.methodName\s*=\s*"beta.compute.routes.patch"\s*OR\s*protoPayload.methodName\s*=\s*"beta.compute.routes.insert"\s*'
                    THEN 'fail'
                ELSE 'pass'
                END AS status
    FROM gcp_logging_metrics
{% endmacro %}

{% macro snowflake__logging_vpc_route_changes_without_log_metric_filter_alerts(framework, check_id) %}
select 
                filter                                                                   AS resource_id,
                '{{framework}}' As framework,
                '{{check_id}}' As check_id,                                                                         
                'Ensure that the log metric filter and alerts exist for VPC network route changes (Automated)' AS title,
                project_id                                                                AS project_id,
                CASE
                WHEN
                            disabled = FALSE
                        AND filter REGEXP
                            '\s*resource.type\s*=\s*"gce_route"\s*AND\s*protoPayload.methodName\s*=\s*"beta.compute.routes.patch"\s*OR\s*protoPayload.methodName\s*=\s*"beta.compute.routes.insert"\s*'
                    THEN 'fail'
                ELSE 'pass'
                END AS status
    FROM gcp_logging_metrics
{% endmacro %}

{% macro bigquery__logging_vpc_route_changes_without_log_metric_filter_alerts(framework, check_id) %}
select DISTINCT 
                filter                                                                    AS resource_id,
                '{{framework}}' As framework,
                '{{check_id}}' As check_id,                                                                         
                'Ensure that the log metric filter and alerts exist for VPC network route changes (Automated)' AS title,
                project_id                                                                AS project_id,
                CASE
                WHEN
                            disabled = FALSE
                        AND REGEXP_CONTAINS(filter, r'\s*resource.type\s*=\s*"gce_route"\s*AND\s*protoPayload.methodName\s*=\s*"beta.compute.routes.patch"\s*OR\s*protoPayload.methodName\s*=\s*"beta.compute.routes.insert"\s*')
                THEN 'fail'
                ELSE 'pass'
                END AS status
    FROM {{ full_table_name("gcp_logging_metrics") }}
{% endmacro %}