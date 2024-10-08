{% macro compute_serial_port_connection_enabled(framework, check_id) %}
  {{ return(adapter.dispatch('compute_serial_port_connection_enabled')(framework, check_id)) }}
{% endmacro %}

{% macro default__compute_serial_port_connection_enabled(framework, check_id) %}{% endmacro %}

{% macro postgres__compute_serial_port_connection_enabled(framework, check_id) %}
select
                "name"                                                                   AS resource_id,
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

{% macro snowflake__compute_serial_port_connection_enabled(framework, check_id) %}
select
                name                                                                   AS resource_id,
                '{{framework}}' As framework,
                '{{check_id}}' As check_id,                                                                         
                'Ensure "Enable connecting to serial ports" is not enabled for VM Instance (Automated)' AS title,
                project_id                                                                AS project_id,
                CASE
           WHEN
             gcmi.value:key = 'serial-port-enable' AND gcmi.value:value IN ('1', 'true', 'True', 'TRUE', 'y', 'yes')
               THEN 'fail'
           ELSE 'pass'
           END AS status
    FROM gcp_compute_instances gci, 
        LATERAL FLATTEN(input => gci.metadata:items) AS gcmi
{% endmacro %}

{% macro bigquery__compute_serial_port_connection_enabled(framework, check_id) %}
select
                name                                                                   AS resource_id,
                '{{framework}}' As framework,
                '{{check_id}}' As check_id,                                                                         
                'Ensure "Enable connecting to serial ports" is not enabled for VM Instance (Automated)' AS title,
                project_id                                                                AS project_id,
                CASE
           WHEN
             JSON_VALUE(gcmi.key) = 'serial-port-enable' AND JSON_VALUE(gcmi.value) IN ('1', 'true', 'True', 'TRUE', 'y', 'yes')
               THEN 'fail'
           ELSE 'pass'
           END AS status
    FROM {{ full_table_name("gcp_compute_instances") }} gci, 
        UNNEST(JSON_QUERY_ARRAY(metadata.items)) AS gcmi
{% endmacro %}