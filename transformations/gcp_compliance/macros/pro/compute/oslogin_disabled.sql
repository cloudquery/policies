{% macro compute_oslogin_disabled(framework, check_id) %}
  {{ return(adapter.dispatch('compute_oslogin_disabled')(framework, check_id)) }}
{% endmacro %}

{% macro default__compute_oslogin_disabled(framework, check_id) %}{% endmacro %}

{% macro postgres__compute_oslogin_disabled(framework, check_id) %}
select 
                "name"                                                                   AS resource_id,
                _cq_sync_time As sync_time,
                '{{framework}}' As framework,
                '{{check_id}}' As check_id,                                                                         
                'Ensure oslogin is enabled for a Project (Automated)' AS title,
                project_id                                                                AS project_id,
                CASE
           WHEN
               cimd->>'key' IS NULL OR
               NOT cimd->>'value' = ANY ('{1,true,True,TRUE,y,yes}')
               THEN 'fail'
           ELSE 'pass'
           END AS status
    FROM gcp_compute_projects
    LEFT JOIN JSONB_ARRAY_ELEMENTS(common_instance_metadata->'items') cimd ON cimd->>'key' = 'enable-oslogin'
{% endmacro %}

{% macro snowflake__compute_oslogin_disabled(framework, check_id) %}
WITH 
    metadata as (
    select
        cimd.value as value             
    FROM gcp_compute_projects,
    LATERAL FLATTEN(input => common_instance_metadata:items) AS cimd
    )

select 
                name                                                                   AS resource_id,
                _cq_sync_time As sync_time,
                '{{framework}}' As framework,
                '{{check_id}}' As check_id,                                                                         
                'Ensure oslogin is enabled for a Project (Automated)' AS title,
                project_id                                                                AS project_id,
                CASE
           WHEN
               cimd.value:key IS NULL OR
               NOT cimd.value:value IN (1, 'true', 'True', 'TRUE', 'y', 'yes')
               THEN 'fail'
           ELSE 'pass'
           END AS status
    FROM gcp_compute_projects
    LEFT JOIN 
    metadata AS cimd ON cimd.value:key ='enable-oslogin'
{% endmacro %}
