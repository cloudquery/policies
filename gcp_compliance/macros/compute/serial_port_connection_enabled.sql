{% macro compute_serial_port_connection_enabled(framework, check_id) %}
    select
                "name"                                                                   AS resource_id,
                _cq_sync_time As sync_time,
                '{{framework}}' As framework,
                '{{check_id}}' As check_id,                                                                         
                'Ensure "Enable connecting to serial ports" is not enabled for VM Instance (Automated)' AS title,
                project_id                                                                AS project_id,
                CASE
           WHEN
             gcmi->>'key' = 'serial-port-enable' AND gcmi->>'value' = ANY ('{1,true,True,TRUE,y,yes}')
               THEN 'fail'
           ELSE 'pass'
           END AS status
    FROM gcp_compute_instances gci, JSONB_ARRAY_ELEMENTS(gci.metadata->'items') gcmi
{% endmacro %}