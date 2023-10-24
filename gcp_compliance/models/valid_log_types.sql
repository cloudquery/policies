WITH project_policy_audit_configs AS (SELECT _cq_sync_time, project_id,
                                             jsonb_array_elements(audit_configs) AS audit_config
                                      FROM gcp_resourcemanager_project_policies where audit_configs != 'null'),
     log_types AS (SELECT _cq_sync_time,
				   		  project_id,
                          audit_config ->> 'service'                                                    AS "service",
                          jsonb_array_elements(audit_config -> 'auditLogConfigs') ->> 'logType'         AS logs,
                          jsonb_array_elements(audit_config -> 'auditLogConfigs') ->> 'exemptedMembers' AS exempted
                   FROM project_policy_audit_configs)
SELECT _cq_sync_time, project_id, service, count(*) as valid_types
                     FROM log_types
                     WHERE exempted IS NULL
                     AND logs IN ('ADMIN_READ', 'DATA_READ', 'DATA_WRITE')
                     AND service = 'allServices'
                     GROUP BY _cq_sync_time, project_id, service