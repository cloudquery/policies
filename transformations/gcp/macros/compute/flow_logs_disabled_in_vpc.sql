{% macro compute_flow_logs_disabled_in_vpc(framework, check_id) %}
  {{ return(adapter.dispatch('compute_flow_logs_disabled_in_vpc')(framework, check_id)) }}
{% endmacro %}

{% macro default__compute_flow_logs_disabled_in_vpc(framework, check_id) %}{% endmacro %}

{% macro postgres__compute_flow_logs_disabled_in_vpc(framework, check_id) %}
select
    DISTINCT 
                gcn.name                                                                    AS resource_id,
                gcn._cq_sync_time As sync_time,
                '{{framework}}' As framework,
                '{{check_id}}' As check_id,                                                                         
                'Ensure that VPC Flow Logs is enabled for every subnet in a VPC Network (Automated)' AS title,
                gcn.project_id                                                                AS project_id,
                CASE
                    WHEN
                        gcs.enable_flow_logs = FALSE
                        THEN 'fail'
                    ELSE 'pass'
                    END AS status
    FROM gcp_compute_networks gcn
            JOIN gcp_compute_subnetworks gcs ON
        gcn.self_link = gcs.network
{% endmacro %}

{% macro snowflake__compute_flow_logs_disabled_in_vpc(framework, check_id) %}
select
    DISTINCT 
                gcn.name                                                                    AS resource_id,
                gcn._cq_sync_time As sync_time,
                '{{framework}}' As framework,
                '{{check_id}}' As check_id,                                                                         
                'Ensure that VPC Flow Logs is enabled for every subnet in a VPC Network (Automated)' AS title,
                gcn.project_id                                                                AS project_id,
                CASE
                    WHEN
                        gcs.enable_flow_logs = FALSE
                        THEN 'fail'
                    ELSE 'pass'
                    END AS status
    FROM gcp_compute_networks gcn
            JOIN gcp_compute_subnetworks gcs ON
        gcn.self_link = gcs.network
{% endmacro %}