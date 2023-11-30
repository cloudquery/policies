{% macro compute_instances_without_confidential_computing(framework, check_id) %}
  {{ return(adapter.dispatch('compute_instances_without_confidential_computing')(framework, check_id)) }}
{% endmacro %}

{% macro default__compute_instances_without_confidential_computing(framework, check_id) %}{% endmacro %}

{% macro postgres__compute_instances_without_confidential_computing(framework, check_id) %}
select 
                "name"                                                                   AS resource_id,
                '{{framework}}' As framework,
                '{{check_id}}' As check_id,                                                                         
                'Ensure that Compute instances have Confidential Computing enabled (Automated)' AS title,
                project_id                                                                AS project_id,
                CASE
                WHEN
                    (confidential_instance_config->>'enable_confidential_compute')::boolean = FALSE
                    THEN 'fail'
                ELSE 'pass'
                END AS status
    FROM gcp_compute_instances
{% endmacro %}

{% macro snowflake__compute_instances_without_confidential_computing(framework, check_id) %}
select 
                name                                                                   AS resource_id,
                '{{framework}}' As framework,
                '{{check_id}}' As check_id,                                                                         
                'Ensure that Compute instances have Confidential Computing enabled (Automated)' AS title,
                project_id                                                                AS project_id,
                CASE
                WHEN
                    (confidential_instance_config:enable_confidential_compute)::boolean = FALSE
                    THEN 'fail'
                ELSE 'pass'
                END AS status
    FROM gcp_compute_instances
{% endmacro %}

{% macro bigquery__compute_instances_without_confidential_computing(framework, check_id) %}
select 
                name                                                                   AS resource_id,
                '{{framework}}' As framework,
                '{{check_id}}' As check_id,                                                                         
                'Ensure that Compute instances have Confidential Computing enabled (Automated)' AS title,
                project_id                                                                AS project_id,
                CASE
                WHEN
                    CAST( JSON_VALUE(confidential_instance_config.enable_confidential_compute) AS BOOL) = FALSE
                    THEN 'fail'
                ELSE 'pass'
                END AS status
    FROM {{ full_table_name("gcp_compute_instances") }}
{% endmacro %}