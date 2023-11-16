{% macro compute_os_and_data_disks_encrypted_with_cmk(framework, check_id) %}
  {{ return(adapter.dispatch('compute_os_and_data_disks_encrypted_with_cmk')(framework, check_id)) }}
{% endmacro %}

{% macro default__compute_os_and_data_disks_encrypted_with_cmk(framework, check_id) %}{% endmacro %}

{% macro postgres__compute_os_and_data_disks_encrypted_with_cmk(framework, check_id) %}
SELECT v._cq_sync_time As sync_time,
       '{{framework}}' As framework,
       '{{check_id}}' As check_id,
       'Ensure that ''OS and Data'' disks are encrypted with CMK (Automated)' AS title,
       v.subscription_id                                                      AS subscription_id,
       v.id                                                                   AS resource_id,
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
SELECT v._cq_sync_time As sync_time,
       '{{framework}}' As framework,
       '{{check_id}}' As check_id,
       'Ensure that ''OS and Data'' disks are encrypted with CMK (Automated)' AS title,
       v.subscription_id                                                      AS subscription_id,
       v.id                                                                   AS resource_id,
       CASE
           WHEN d.properties:encryption:type NOT LIKE '%CustomerKey%'
               THEN 'fail'
           ELSE 'pass'
           END                                                                AS status
FROM azure_compute_virtual_machines v
         JOIN azure_compute_disks d ON
    LOWER(v.id) = LOWER(d.properties:managedBy)
{% endmacro %}