{% macro compute_vms_utilizing_managed_disks(framework, check_id) %}
  {{ return(adapter.dispatch('compute_vms_utilizing_managed_disks')(framework, check_id)) }}
{% endmacro %}

{% macro default__compute_vms_utilizing_managed_disks(framework, check_id) %}{% endmacro %}

{% macro postgres__compute_vms_utilizing_managed_disks(framework, check_id) %}
SELECT
         id                                                             AS resource_id,
        '{{framework}}' As framework,
       '{{check_id}}' As check_id,
       'Ensure Virtual Machines are utilizing Managed Disks (Manual)' AS title,
       subscription_id                                                AS subscription_id,
       CASE
           WHEN properties -> 'storageProfile' -> 'osDisk' -> 'managedDisk' -> 'id' IS NULL
               THEN 'fail'
           ELSE 'pass'
           END                                                        AS status
FROM azure_compute_virtual_machines
{% endmacro %}

{% macro snowflake__compute_vms_utilizing_managed_disks(framework, check_id) %}
SELECT
       id                                                             AS resource_id,
       '{{framework}}' As framework,
       '{{check_id}}' As check_id,
       'Ensure Virtual Machines are utilizing Managed Disks (Manual)' AS title,
       subscription_id                                                AS subscription_id,
       CASE
           WHEN properties:storageProfile:osDisk:managedDisk:id IS NULL
               THEN 'fail'
           ELSE 'pass'
           END                                                        AS status
FROM azure_compute_virtual_machines
{% endmacro %}

{% macro bigquery__compute_vms_utilizing_managed_disks(framework, check_id) %}
SELECT
       id                                                             AS resource_id,
       '{{framework}}' As framework,
       '{{check_id}}' As check_id,
       'Ensure Virtual Machines are utilizing Managed Disks (Manual)' AS title,
       subscription_id                                                AS subscription_id,
       CASE
           WHEN JSON_VALUE(properties.storageProfile.osDisk.managedDisk.id) IS NULL
               THEN 'fail'
           ELSE 'pass'
           END                                                        AS status
FROM {{ full_table_name("azure_compute_virtual_machines") }}
{% endmacro %}