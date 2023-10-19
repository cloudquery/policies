-- query 5.1.1
\echo "rbac_and_service_accounts_5.1.1"

INSERT INTO k8s_policy_results (resource_id, execution_time, framework, check_id, title, context, namespace,
                                resource_name, status)
select uid                              AS resource_id,
        :'execution_time'::timestamp     AS execution_time,
        :'framework'                     AS framework,
        'rbac_and_service_accounts_5.1.1'                      AS check_id,
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
\echo "rbac_and_service_accounts_5.1.2"

INSERT INTO k8s_policy_results (resource_id, execution_time, framework, check_id, title, context, namespace,
                                resource_name, status)
select uid                              AS resource_id,
        :'execution_time'::timestamp     AS execution_time,
        :'framework'                     AS framework,
        'rbac_and_service_accounts_5.1.2'                      AS check_id,
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
\echo "rbac_and_service_accounts_5.1.3"

INSERT INTO k8s_policy_results (resource_id, execution_time, framework, check_id, title, context, namespace,
                                resource_name, status)
select uid                              AS resource_id,
        :'execution_time'::timestamp     AS execution_time,
        :'framework'                     AS framework,
        'rbac_and_service_accounts_5.1.3'                      AS check_id,
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
        'rbac_and_service_accounts_5.1.3'                      AS check_id,
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

-- query 5.1.4
\echo "rbac_and_service_accounts_5.1.4"

INSERT INTO k8s_policy_results (resource_id, execution_time, framework, check_id, title, context, namespace,
                                resource_name, status)
select uid                              AS resource_id,
        :'execution_time'::timestamp     AS execution_time,
        :'framework'                     AS framework,
        'rbac_and_service_accounts_5.1.4'                      AS check_id,
        'Minimize access to create pods' AS title,
        context                          AS context,
        namespace                        AS namespace,
        name                             AS resource_name,
        case
          when 
          rule -> 'resources' ? 'pod' and rule ->'verbs' ? 'create'
          then 'fail'
          else 'pass'
        end as status
from
  k8s_rbac_cluster_roles,
  jsonb_array_elements(rules) rule
where
  name not like '%system%';

-- query 5.1.5
\echo "rbac_and_service_accounts_5.1.5"

INSERT INTO k8s_policy_results (resource_id, execution_time, framework, check_id, title, context, namespace,
                                resource_name, status)
select uid                              AS resource_id,
        :'execution_time'::timestamp     AS execution_time,
        :'framework'                     AS framework,
        'rbac_and_service_accounts_5.1.5'                      AS check_id,
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
  k8s_core_service_accounts;

-- query 5.1.6
\echo "rbac_and_service_accounts_5.1.6"

INSERT INTO k8s_policy_results (resource_id, execution_time, framework, check_id, title, context, namespace,
                                resource_name, status)
select uid                              AS resource_id,
        :'execution_time'::timestamp     AS execution_time,
        :'framework'                     AS framework,
        'rbac_and_service_accounts_5.1.6'                      AS check_id,
        'Ensure that Service Account Tokens are only mounted where necessary' AS title,
        context                          AS context,
        namespace                        AS namespace,
        name                             AS resource_name,
        case
          when
          automount_service_account_token = true
          then 'fail'
          else 'pass'
        end as status
FROM
  k8s_core_service_accounts;

-- query 5.1.7
\echo "rbac_and_service_accounts_5.1.7"

INSERT INTO k8s_policy_results (resource_id, execution_time, framework, check_id, title, context, namespace,
                                resource_name, status)
select uid                              AS resource_id,
        :'execution_time'::timestamp     AS execution_time,
        :'framework'                     AS framework,
        'rbac_and_service_accounts_5.1.7'                      AS check_id,
        'Avoid use of system:masters group' AS title,
        context                          AS context,
        namespace                        AS namespace,
        name                             AS resource_name,
        case
          when sub ->> 'name' like 'system:masters'
          then 'fail'
          else 'pass'
        end as status
from
  k8s_rbac_cluster_role_bindings,
  jsonb_array_elements(subjects) sub;

-- query 5.1.8
\echo "rbac_and_service_accounts_5.1.8"

INSERT INTO k8s_policy_results (resource_id, execution_time, framework, check_id, title, context, namespace,
                                resource_name, status)
select uid                              AS resource_id,
        :'execution_time'::timestamp     AS execution_time,
        :'framework'                     AS framework,
        'rbac_and_service_accounts_5.1.8'                      AS check_id,
        'Limit use of the Bind, Impersonate and Escalate permissions in the Kubernetes cluster' AS title,
        context                          AS context,
        namespace                        AS namespace,
        name                             AS resource_name,
        case when
          rule -> 'verbs' ?| array['bind', 'impersonate', 'escalate']
          then 'fail'
          else 'pass'
        end as status
from
  k8s_rbac_cluster_roles,
  jsonb_array_elements(rules) rule;

-- query 5.1.9
\echo "rbac_and_service_accounts_5.1.9"

INSERT INTO k8s_policy_results (resource_id, execution_time, framework, check_id, title, context, namespace,
                                resource_name, status)
select uid                              AS resource_id,
        :'execution_time'::timestamp     AS execution_time,
        :'framework'                     AS framework,
        'rbac_and_service_accounts_5.1.9'                      AS check_id,
        'Minimize access to create persistent volumes' AS title,
        context                          AS context,
        namespace                        AS namespace,
        name                             AS resource_name,
        case
          when 
            rule -> 'resources' ? 'PersistentVolume' and rule ->'verbs' ? 'create'
          then 'fail'
          else 'pass'
        end as status
from
  k8s_rbac_cluster_roles,
  jsonb_array_elements(rules) rule
UNION
select uid                              AS resource_id,
        :'execution_time'::timestamp     AS execution_time,
        :'framework'                     AS framework,
        'rbac_and_service_accounts_5.1.9'                      AS check_id,
        'Minimize access to create persistent volumes' AS title,
        context                          AS context,
        namespace                        AS namespace,
        name                             AS resource_name,
        case
          when 
            rule -> 'resources' ? 'PersistentVolume' and rule ->'verbs' ? 'create'
          then 'fail'
          else 'pass'
        end as status
from
  k8s_rbac_roles,
  jsonb_array_elements(rules) rule;

-- query 5.1.10
\echo "rbac_and_service_accounts_5.1.10"

INSERT INTO k8s_policy_results (resource_id, execution_time, framework, check_id, title, context, namespace,
                                resource_name, status)
select uid                              AS resource_id,
        :'execution_time'::timestamp     AS execution_time,
        :'framework'                     AS framework,
        'rbac_and_service_accounts_5.1.10'                      AS check_id,
        'Minimize access to the proxy sub-resource of nodes' AS title,
        context                          AS context,
        namespace                        AS namespace,
        name                             AS resource_name,
        case
          when 
            rule -> 'resources' ? 'nodes/proxy' and rule ->'verbs' ?| array['get', '*']
          then 'fail'
          else 'pass'
        end as status
from
  k8s_rbac_cluster_roles,
  jsonb_array_elements(rules) rule;

-- query 5.1.11
\echo "rbac_and_service_accounts_5.1.11"

INSERT INTO k8s_policy_results (resource_id, execution_time, framework, check_id, title, context, namespace,
                                resource_name, status)
select uid                              AS resource_id,
        :'execution_time'::timestamp     AS execution_time,
        :'framework'                     AS framework,
        'rbac_and_service_accounts_5.1.11'                      AS check_id,
        'Minimize access to the approval sub-resource of certificatesigningrequests objects' AS title,
        context                          AS context,
        namespace                        AS namespace,
        name                             AS resource_name,
       	case
          when 
            rule -> 'resources' ? 'certificatesigningrequests/approval' and rule ->'verbs' ?| array['update', '*']
          then 'fail'
          else 'pass'
        end as status
from
  k8s_rbac_cluster_roles,
  jsonb_array_elements(rules) rule;

-- query 5.1.12
\echo "rbac_and_service_accounts_5.1.12"

INSERT INTO k8s_policy_results (resource_id, execution_time, framework, check_id, title, context, namespace,
                                resource_name, status)
select uid                              AS resource_id,
        :'execution_time'::timestamp     AS execution_time,
        :'framework'                     AS framework,
        'rbac_and_service_accounts_5.1.12'                      AS check_id,
        'Minimize access to webhook configuration objects' AS title,
        context                          AS context,
        namespace                        AS namespace,
        name                             AS resource_name,
       	case
          when 
            rule -> 'resources' ?| array['validatingwebhookconfigurations', 'mutatingwebhookconfigurations'] and rule ->'verbs' ?| array['get', '*']
          then 'fail'
          else 'pass'
        end as status
from
  k8s_rbac_cluster_roles,
  jsonb_array_elements(rules) rule;

-- query 5.1.13
\echo "rbac_and_service_accounts_5.1.13"

INSERT INTO k8s_policy_results (resource_id, execution_time, framework, check_id, title, context, namespace,
                                resource_name, status)
select uid                              AS resource_id,
        :'execution_time'::timestamp     AS execution_time,
        :'framework'                     AS framework,
        'rbac_and_service_accounts_5.1.13'                      AS check_id,
        'Minimize access to the service account token creation' AS title,
        context                          AS context,
        namespace                        AS namespace,
        name                             AS resource_name,
       	case
          when 
            rule -> 'resources' ? 'serviceaccounts/token' and rule ->'verbs' ?| array['create', '*']
          then 'fail'
          else 'pass'
        end as status
from
  k8s_rbac_cluster_roles,
  jsonb_array_elements(rules) rule;