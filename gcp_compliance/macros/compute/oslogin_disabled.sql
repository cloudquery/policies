{% macro compute_oslogin_disabled(framework, check_id) %}
    select 
                "name"                                                                   AS resource_id,
                _cq_sync_time As execution_time,
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