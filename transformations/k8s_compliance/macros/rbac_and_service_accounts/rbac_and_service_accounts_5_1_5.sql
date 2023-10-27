{% macro rbac_and_service_accounts_5_1_5(framework, check_id) %}
select uid                              AS resource_id,
        '{{framework}}' As framework,
        '{{check_id}}'  As check_id,
        'Ensure that default service accounts are not actively used' AS title,
        context                          AS context,
        namespace                        AS namespace,
        name                             AS resource_name,
        case
          when 
          name = 'default'
          AND NOT namespace ~ 'kube.*'
          AND automount_service_account_token = false
          then 'fail'
          else 'pass'
        end as status
FROM
  k8s_core_service_accounts


{% endmacro %}