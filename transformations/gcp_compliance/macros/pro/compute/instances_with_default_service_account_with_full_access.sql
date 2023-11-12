{% macro compute_instances_with_default_service_account_with_full_access(framework, check_id) %}
  {{ return(adapter.dispatch('compute_instances_with_default_service_account_with_full_access')(framework, check_id)) }}
{% endmacro %}

{% macro default__compute_instances_with_default_service_account_with_full_access(framework, check_id) %}{% endmacro %}

{% macro postgres__compute_instances_with_default_service_account_with_full_access(framework, check_id) %}
select
    DISTINCT 
                gci.name                                                                    AS resource_id,
                gci._cq_sync_time As sync_time,
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

{% macro snowflake__compute_instances_with_default_service_account_with_full_access(framework, check_id) %}
select
    DISTINCT 
                gci.name                                                                    AS resource_id,
                gci._cq_sync_time As sync_time,
                '{{framework}}' As framework,
                '{{check_id}}' As check_id,                                                                         
                'Ensure that instances are not configured to use the default service account with full access to all Cloud APIs (Automated)' AS title,
                gci.project_id                                                                AS project_id,
                CASE
                    WHEN
                            gcisa.value:email = (SELECT default_service_account
                                               FROM gcp_compute_projects
                                               WHERE project_id = gci.project_id)
                            AND array_contains('https://www.googleapis.com/auth/cloud-platform'::variant, gcisa.value:scopes)
                        THEN 'fail'
                    ELSE 'pass'
                    END AS status
    FROM gcp_compute_instances gci,
    LATERAL FLATTEN(service_accounts) gcisa
{% endmacro %}