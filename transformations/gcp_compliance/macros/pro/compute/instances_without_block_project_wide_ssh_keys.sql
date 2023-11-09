{% macro compute_instances_without_block_project_wide_ssh_keys(framework, check_id) %}
  {{ return(adapter.dispatch('compute_instances_without_block_project_wide_ssh_keys')(framework, check_id)) }}
{% endmacro %}

{% macro default__compute_instances_without_block_project_wide_ssh_keys(framework, check_id) %}{% endmacro %}

{% macro postgres__compute_instances_without_block_project_wide_ssh_keys(framework, check_id) %}
select 
                gci.name                                                                   AS resource_id,
                gci._cq_sync_time As sync_time,
                '{{framework}}' As framework,
                '{{check_id}}' As check_id,                                                                         
                'Ensure "Block Project-wide SSH keys" is enabled for VM instances (Automated)' AS title,
                gci.project_id                                                                AS project_id,
                CASE
                WHEN
                        gcmi->>'key' IS NULL OR
                        NOT gcmi->>'value' = ANY ('{1,true,True,TRUE,y,yes}')
                    THEN 'fail'
                ELSE 'pass'
                END AS status
    FROM gcp_compute_instances gci
    LEFT JOIN JSONB_ARRAY_ELEMENTS(gci.metadata->'items') gcmi ON gcmi->>'key' = 'block-project-ssh-keys'
{% endmacro %}

{% macro snowflake__compute_instances_without_block_project_wide_ssh_keys(framework, check_id) %}
---
{% endmacro %}