-- query 5.1.1
INSERT INTO k8s_policy_results (resource_id, execution_time, framework, check_id, title, context, namespace,
                                resource_name, status)
select uid                              AS resource_id,
        :'execution_time'::timestamp     AS execution_time,
        :'framework'                     AS framework,
        'cluster_admin_role'                      AS check_id,
        'cluster-admin role is only used where required' AS title,
        context                          AS context,
        namespace                        AS namespace,
        name                             AS resource_name,
        CASE WHEN
            role_ref->>'name' = 'cluster-admin' then 'fail'
            else 'pass'
            END AS status
FROM 
	k8s_rbac_cluster_role_bindings;

-- query 5.1.2
INSERT INTO k8s_policy_results (resource_id, execution_time, framework, check_id, title, context, namespace,
                                resource_name, status)
select uid                              AS resource_id,
        :'execution_time'::timestamp     AS execution_time,
        :'framework'                     AS framework,
        'minimize_access_to_secrets'                      AS check_id,
        'Minimize access to secrets' AS title,
        context                          AS context,
        namespace                        AS namespace,
        name                             AS resource_name,
        case
            when rule -> 'resources' ? 'secrets' and rule -> 'verbs'  ?| array['get', 'list'] then 'fail'
            when rule -> 'resources' ? 'secrets' and rule -> 'verbs'  ?| array['watch'] then 'fail'
            else 'pass'
        end as status
from
  k8s_rbac_cluster_roles,
  jsonb_array_elements(rules) rule
where
  name not like '%system%';

-- query 5.1.3
INSERT INTO k8s_policy_results (resource_id, execution_time, framework, check_id, title, context, namespace,
                                resource_name, status)
select uid                              AS resource_id,
        :'execution_time'::timestamp     AS execution_time,
        :'framework'                     AS framework,
        'minimize_wildcard_use'                      AS check_id,
        'Minimize wildcard use in Roles and ClusterRoles' AS title,
        context                          AS context,
        namespace                        AS namespace,
        name                             AS resource_name,
        	case
    when rule ->> 'apiGroups' like '%*%'
    or rule ->> 'resources' like '%*%'
    or rule ->> 'verbs' like '%*%' then 'fail'
    else 'pass'
  end as status
from
  k8s_rbac_cluster_roles,
  jsonb_array_elements(rules) rule
where
  name not like '%system%'
UNION
select
	uid                              AS resource_id,
        :'execution_time'::timestamp     AS execution_time,
        :'framework'                     AS framework,
        'minimize_wildcard_use'                      AS check_id,
        'Minimize wildcard use in Roles and ClusterRoles' AS title,
        context                          AS context,
        namespace                        AS namespace,
        name                             AS resource_name,
        case when
        rule ->> 'apiGroups' like '%*%'
        or rule ->> 'resources' like '%*%'
        or rule ->> 'verbs' like '%*%' then 'fail'
        else 'pass'
        end as status
from
  k8s_rbac_roles,
  jsonb_array_elements(rules) rule
where
  name not like '%system%';