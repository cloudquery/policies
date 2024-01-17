{% macro compute_os_and_data_disks_encrypted_with_cmk(framework, check_id) %}
  {{ return(adapter.dispatch('compute_os_and_data_disks_encrypted_with_cmk')(framework, check_id)) }}
{% endmacro %}

{% macro default__compute_os_and_data_disks_encrypted_with_cmk(framework, check_id) %}{% endmacro %}

{% macro postgres__compute_os_and_data_disks_encrypted_with_cmk(framework, check_id) %}
SELECT   
        v.id                                                                   AS resource_id,
       '{{framework}}' As framework,
       '{{check_id}}' As check_id,
       'Ensure that ''OS and Data'' disks are encrypted with CMK (Automated)' AS title,
       v.subscription_id                                                      AS subscription_id,
       CASE
           WHEN d.properties -> 'encryption' ->> 'type' NOT LIKE '%CustomerKey%'
               THEN 'fail'
           ELSE 'pass'
           END                                                                AS status
FROM azure_compute_virtual_machines v
         JOIN azure_compute_disks d ON
    LOWER(v.id) = LOWER(d.properties ->> 'managedBy')
{% endmacro %}

{% macro snowflake__compute_os_and_data_disks_encrypted_with_cmk(framework, check_id) %}
SELECT 
       v.id                                                                   AS resource_id,
       '{{framework}}' As framework,
       '{{check_id}}' As check_id,
       'Ensure that ''OS and Data'' disks are encrypted with CMK (Automated)' AS title,
       v.subscription_id                                                      AS subscription_id,
       CASE
           WHEN d.properties:encryption:type NOT LIKE '%CustomerKey%'
               THEN 'fail'
           ELSE 'pass'
           END                                                                AS status
FROM azure_compute_virtual_machines v
         JOIN azure_compute_disks d ON
    LOWER(v.id) = LOWER(d.properties:managedBy)
{% endmacro %}

{% macro bigquery__compute_os_and_data_disks_encrypted_with_cmk(framework, check_id) %}
SELECT 
       v.id                                                                   AS resource_id,
       '{{framework}}' As framework,
       '{{check_id}}' As check_id,
       'Ensure that "OS and Data" disks are encrypted with CMK (Automated)' AS title,
       v.subscription_id                                                      AS subscription_id,
       CASE
           WHEN JSON_VALUE(d.properties.encryption.type) NOT LIKE '%CustomerKey%'
               THEN 'fail'
           ELSE 'pass'
           END                                                                AS status
FROM {{ full_table_name("azure_compute_virtual_machines") }} v
         JOIN {{ full_table_name("azure_compute_disks") }} d ON
    LOWER(v.id) = LOWER(JSON_VALUE(d.properties.managedBy))
{% endmacro %}