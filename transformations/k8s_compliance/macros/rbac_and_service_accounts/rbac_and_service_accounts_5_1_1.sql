{% macro rbac_and_service_accounts_5_1_1(framework, check_id) %}
select uid                              AS resource_id,
        '{{framework}}' As framework,
        '{{check_id}}'  As check_id,
        'cluster-admin role is only used where required' AS title,
        context                          AS context,
        namespace                        AS namespace,
        name                             AS resource_name,
        CASE WHEN
            role_ref->>'name' = 'cluster-admin' then 'fail'
            else 'pass'
            END AS status
FROM 
	k8s_rbac_cluster_role_bindings


{% endmacro %}