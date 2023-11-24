{% macro compute_default_network_exist(framework, check_id) %}
  {{ return(adapter.dispatch('compute_default_network_exist')(framework, check_id)) }}
{% endmacro %}

{% macro default__compute_default_network_exist(framework, check_id) %}{% endmacro %}

{% macro postgres__compute_default_network_exist(framework, check_id) %}
select 
                "name"                                                                    AS resource_id,
                _cq_sync_time As sync_time,
                '{{framework}}' As framework,
                '{{check_id}}' As check_id,                                                                         
                'Ensure that the default network does not exist in a project (Automated)' AS title,
                project_id                                                                AS project_id,
                CASE
                WHEN
                    "name" = 'default'
                    THEN 'fail'
                ELSE 'pass'
                END                                                                   AS status
    FROM gcp_compute_networks
{% endmacro %}

{% macro snowflake__compute_default_network_exist(framework, check_id) %}
select 
                name                                                                    AS resource_id,
                _cq_sync_time As sync_time,
                '{{framework}}' As framework,
                '{{check_id}}' As check_id,                                                                         
                'Ensure that the default network does not exist in a project (Automated)' AS title,
                project_id                                                                AS project_id,
                CASE
                WHEN
                    name = 'default'
                    THEN 'fail'
                ELSE 'pass'
                END                                                                   AS status
    FROM gcp_compute_networks
{% endmacro %}