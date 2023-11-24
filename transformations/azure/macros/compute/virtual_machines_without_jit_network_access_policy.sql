{% macro compute_virtual_machines_without_jit_network_access_policy(framework, check_id) %}
WITH jit_vms AS (SELECT properties->'virtualMachines'->>'id' AS vm_id
                 FROM azure_security_jit_network_access_policies
                 WHERE properties->>'provisioningState' = 'Succeeded')


SELECT _cq_sync_time As sync_time,
       '{{framework}}' As framework,
       '{{check_id}}' As check_id,
       'Management ports of virtual machines should be protected with just-in-time network access control' AS title,
       subscription_id                                                                                     AS subscription_id,
       id                                                                                                  AS resource_id,
       CASE
           WHEN j.vm_id = NULL
               THEN 'fail'
           ELSE 'pass'
           END                                                                                             AS status
FROM azure_compute_virtual_machines vm
         LEFT JOIN jit_vms j ON vm.id = j.vm_id
{% endmacro %}