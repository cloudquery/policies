{% macro compute_vhds_not_encrypted(framework, check_id) %}

SELECT _cq_sync_time As sync_time,
       '{{framework}}' As framework,
       '{{check_id}}' As check_id,
       'Ensure that VHD''s are encrypted (Manual)' AS title,
       subscription_id                             AS subscription_id,
       id                                          AS resource_id,
       CASE
           WHEN (properties -> 'encryptionSettingsCollection' ->> 'enabled')::boolean IS DISTINCT FROM TRUE
           THEN 'fail'
           ELSE 'pass'
       END                                         AS status
FROM azure_compute_disks
{% endmacro %}