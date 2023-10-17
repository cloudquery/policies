{% macro compute_instances_with_default_service_account_with_full_access(framework, check_id) %}
    select
    DISTINCT 
                gci.name                                                                    AS resource_id,
                gci._cq_sync_time As execution_time,
                '{{framework}}' As framework,
                '{{check_id}}' As check_id,                                                                         
                'Ensure that instances are not configured to use the default service account with full access to all Cloud APIs (Automated)' AS title,
                gci.project_id                                                                AS project_id,
                CASE
                    WHEN
                            gcisa->>'email' = (SELECT default_service_account
                                               FROM gcp_compute_projects
                                               WHERE project_id = gci.project_id)
                            AND ARRAY['https://www.googleapis.com/auth/cloud-platform'] <@ ARRAY(SELECT JSONB_ARRAY_ELEMENTS_TEXT(gcisa->'scopes'))
                        THEN 'fail'
                    ELSE 'pass'
                    END AS status
    FROM gcp_compute_instances gci, JSONB_ARRAY_ELEMENTS(gci.service_accounts) gcisa
{% endmacro %}