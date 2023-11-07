SELECT _cq_sync_time, project_id, name, count(*) AS configured_sinks
                     FROM gcp_logging_sinks gls
                     WHERE gls.FILTER = ''
                     GROUP BY _cq_sync_time, project_id, name