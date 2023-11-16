{% macro compute_instances_with_shielded_vm_disabled(framework, check_id) %}
  {{ return(adapter.dispatch('compute_instances_with_shielded_vm_disabled')(framework, check_id)) }}
{% endmacro %}

{% macro default__compute_instances_with_shielded_vm_disabled(framework, check_id) %}{% endmacro %}

{% macro postgres__compute_instances_with_shielded_vm_disabled(framework, check_id) %}
select 
                "name"                                                                   AS resource_id,
                _cq_sync_time As sync_time,
                '{{framework}}' As framework,
                '{{check_id}}' As check_id,                                                                         
                'Ensure Compute instances are launched with Shielded VM enabled (Automated)' AS title,
                project_id                                                                AS project_id,
                CASE
                WHEN
                    (shielded_instance_config->>'enable_integrity_monitoring')::boolean = FALSE
                        OR (shielded_instance_config->>'enable_vtpm')::boolean = FALSE
                        OR (shielded_instance_config->>'enable_secure_boot')::boolean = FALSE
                    THEN 'fail'
                ELSE 'pass'
                END AS status
    FROM gcp_compute_instances
{% endmacro %}

{% macro snowflake__compute_instances_with_shielded_vm_disabled(framework, check_id) %}
select 
                name                                                                   AS resource_id,
                _cq_sync_time As sync_time,
                '{{framework}}' As framework,
                '{{check_id}}' As check_id,                                                                         
                'Ensure Compute instances are launched with Shielded VM enabled (Automated)' AS title,
                project_id                                                                AS project_id,
                CASE
                WHEN
                    (shielded_instance_config:enable_integrity_monitoring)::boolean = FALSE
                        OR (shielded_instance_config:enable_vtpm)::boolean = FALSE
                        OR (shielded_instance_config:enable_secure_boot)::boolean = FALSE
                    THEN 'fail'
                ELSE 'pass'
                END AS status
    FROM gcp_compute_instances
{% endmacro %}