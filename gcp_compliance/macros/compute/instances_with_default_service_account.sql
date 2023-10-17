{% macro compute_instances_with_default_service_account(framework, check_id) %}
    select
    DISTINCT 
                gci.name                                                                    AS resource_id,
                gci._cq_sync_time As execution_time,
                '{{framework}}' As framework,
                '{{check_id}}' As check_id,                                                                         
                'Ensure that instances are not configured to use the default service account (Automated)' AS title,
                gci.project_id                                                                AS project_id,
                CASE
                    WHEN
                                gci."name" NOT LIKE 'gke-'
                            AND gcisa->>'email' = (SELECT default_service_account
                                               FROM gcp_compute_projects
                                               WHERE project_id = gci.project_id)
                        THEN 'fail'
                    ELSE 'pass'
                    END AS status
    FROM gcp_compute_instances gci, JSONB_ARRAY_ELEMENTS(gci.service_accounts) gcisa
{% endmacro %}