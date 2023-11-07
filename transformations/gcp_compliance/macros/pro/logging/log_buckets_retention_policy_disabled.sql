{% macro logging_log_buckets_retention_policy_disabled(framework, check_id) %}
    select DISTINCT 
                gsb.name                                                                    AS resource_id,
                gsb._cq_sync_time As sync_time,
                '{{framework}}' As framework,
                '{{check_id}}' As check_id,                                                                         
                'Ensure that retention policies on log buckets are configured using Bucket Lock (Automated)' AS title,
                gsb.project_id                                                                AS project_id,
                CASE
                    WHEN
                                gls.destination LIKE 'storage.googleapis.com/%'
                            AND ((gsb.retention_policy->>'IsLocked')::boolean = FALSE
                            OR (gsb.retention_policy->>'RetentionPeriod')::integer = 0)
                        THEN 'fail'
                    ELSE 'pass'
                    END AS status
    FROM gcp_logging_sinks gls
            JOIN gcp_storage_buckets gsb ON
        gsb.name = REPLACE(gls.destination, 'storage.googleapis.com/', '')
{% endmacro %}