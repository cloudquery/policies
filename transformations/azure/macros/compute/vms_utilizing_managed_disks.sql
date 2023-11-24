{% macro compute_vms_utilizing_managed_disks(framework, check_id) %}
  {{ return(adapter.dispatch('compute_vms_utilizing_managed_disks')(framework, check_id)) }}
{% endmacro %}

{% macro default__compute_vms_utilizing_managed_disks(framework, check_id) %}{% endmacro %}

{% macro postgres__compute_vms_utilizing_managed_disks(framework, check_id) %}
SELECT _cq_sync_time As sync_time,
       '{{framework}}' As framework,
       '{{check_id}}' As check_id,
       'Ensure Virtual Machines are utilizing Managed Disks (Manual)' AS title,
       subscription_id                                                AS subscription_id,
       id                                                             AS resource_id,
       CASE
           WHEN properties -> 'storageProfile' -> 'osDisk' -> 'managedDisk' -> 'id' IS NULL
               THEN 'fail'
           ELSE 'pass'
           END                                                        AS status
FROM azure_compute_virtual_machines
{% endmacro %}

{% macro snowflake__compute_vms_utilizing_managed_disks(framework, check_id) %}
SELECT _cq_sync_time As sync_time,
       '{{framework}}' As framework,
       '{{check_id}}' As check_id,
       'Ensure Virtual Machines are utilizing Managed Disks (Manual)' AS title,
       subscription_id                                                AS subscription_id,
       id                                                             AS resource_id,
       CASE
           WHEN properties:storageProfile:osDisk:managedDisk:id IS NULL
               THEN 'fail'
           ELSE 'pass'
           END                                                        AS status
FROM azure_compute_virtual_machines
{% endmacro %}