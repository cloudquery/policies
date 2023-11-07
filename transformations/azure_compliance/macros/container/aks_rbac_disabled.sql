{% macro container_aks_rbac_disabled(framework, check_id) %}

SELECT 
    _cq_sync_time As sync_time,
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'Role-Based Access Control (RBAC) should be used on Kubernetes Services' AS title,
    subscription_id                                                          AS subscription_id,
    id                                                                       AS resource_id,
    CASE
        WHEN (properties ->> 'enableRBAC')::boolean IS distinct from TRUE
        THEN 'fail'
        ELSE 'pass'
    END                                                                      AS status
FROM azure_containerservice_managed_clusters
{% endmacro %}