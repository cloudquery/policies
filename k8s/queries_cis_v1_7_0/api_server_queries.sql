-- query 1.2.1
\echo "api_server_1.2.1"

INSERT INTO k8s_policy_results (resource_id, execution_time, framework, check_id, title, context, namespace,
                                resource_name, status)
select uid                              AS resource_id,
        :'execution_time'::timestamp     AS execution_time,
        :'framework'                     AS framework,
        'api_server_1.2.1'                      AS check_id,
        'Ensure that the --anonymous-auth argument is set to false' AS title,
        context,
  	namespace,
  	name AS resource_name,
    case
      when 
        container ->> 'command' like '%anonymous-auth%'
      then 'fail'
      else 'pass'
    end as status
from
  k8s_core_pods,
  jsonb_array_elements(spec_containers) as container
where 
	namespace = 'kube-system' and container ->> 'name' = 'kube-apiserver';

-- query 1.2.2
\echo "api_server_1.2.2"

INSERT INTO k8s_policy_results (resource_id, execution_time, framework, check_id, title, context, namespace,
                                resource_name, status)
select uid                              AS resource_id,
        :'execution_time'::timestamp     AS execution_time,
        :'framework'                     AS framework,
        'api_server_1.2.2'                      AS check_id,
        'Ensure that the --audit-log-maxsize argument is set to 100 or as appropriate' AS title,
    context,
  	namespace,
  	name AS resource_name,
    case 
        when 
        container ->> 'command' like '%audit-log-maxsize%' and
        CAST(REGEXP_REPLACE(container->>'command', '.*--audit-log-maxsize=(\d+).*', '\1') AS INTEGER) < 100
        then 'fail'
        else 'pass'
    end as status
from
  k8s_core_pods,
  jsonb_array_elements(spec_containers) as container
where 
	namespace = 'kube-system' and container ->> 'name' = 'kube-apiserver';

-- query 1.2.3
\echo "api_server_1.2.3"

INSERT INTO k8s_policy_results (resource_id, execution_time, framework, check_id, title, context, namespace,
                                resource_name, status)
select uid                              AS resource_id,
        :'execution_time'::timestamp     AS execution_time,
        :'framework'                     AS framework,
        'api_server_1.2.3'                      AS check_id,
        'Ensure that the DenyServiceExternalIPs is set' AS title,
    context,
  	namespace,
  	name AS resource_name,
    case
      when 
        container ->> 'command' like '%DenyServiceExternalIPs%'
      then 'fail'
      else 'pass'
    end as status
from
  k8s_core_pods,
  jsonb_array_elements(spec_containers) as container
where 
	namespace = 'kube-system' and container ->> 'name' = 'kube-apiserver';

-- query 1.2.4
\echo "api_server_1.2.4"

INSERT INTO k8s_policy_results (resource_id, execution_time, framework, check_id, title, context, namespace,
                                resource_name, status)
select uid                              AS resource_id,
        :'execution_time'::timestamp     AS execution_time,
        :'framework'                     AS framework,
        'api_server_1.2.4'                      AS check_id,
        'Ensure that the --kubelet-client-certificate and --kubelet-client-key arguments are set as appropriate' AS title,
    context,
  	namespace,
  	name AS resource_name,
    case
        when 
          container ->> 'command' like '%kubelet-client-certificate%' 
        and container ->> 'command' like '%kubelet-client-key%'
        then 'pass'
        else 'fail'
    end as status
from
  k8s_core_pods,
  jsonb_array_elements(spec_containers) as container
where 
	namespace = 'kube-system' and container ->> 'name' = 'kube-apiserver';

-- query 1.2.5
\echo "api_server_1.2.5"

INSERT INTO k8s_policy_results (resource_id, execution_time, framework, check_id, title, context, namespace,
                                resource_name, status)
select uid                              AS resource_id,
        :'execution_time'::timestamp     AS execution_time,
        :'framework'                     AS framework,
        'api_server_1.2.5'                      AS check_id,
        'Ensure that the --kubelet-certificate-authority argument is set as appropriate' AS title,
    context,
  	namespace,
  	name AS resource_name,
    case
      when 
        container ->> 'command' like '%kubelet-certificate-authority%' 
      then 'pass'
      else 'fail'
    end as status
from
  k8s_core_pods,
  jsonb_array_elements(spec_containers) as container
where 
	namespace = 'kube-system' and container ->> 'name' = 'kube-apiserver';

-- query 1.2.6
\echo "api_server_1.2.6"

INSERT INTO k8s_policy_results (resource_id, execution_time, framework, check_id, title, context, namespace,
                                resource_name, status)
select uid                              AS resource_id,
        :'execution_time'::timestamp     AS execution_time,
        :'framework'                     AS framework,
        'api_server_1.2.6'                      AS check_id,
        'Ensure that the --authorization-mode argument is not set to AlwaysAllow' AS title,
    context,
  	namespace,
  	name AS resource_name,
    case
      when 
        container ->> 'command' like '%authorization-mode=%' AND
      container ->> 'command' not like '%authorization-mode=%AlwaysAllow%'
      then 'pass'
      else 'fail'
    end as status
from
  k8s_core_pods,
  jsonb_array_elements(spec_containers) as container
where 
	namespace = 'kube-system' and container ->> 'name' = 'kube-apiserver';

  -- query 1.2.7
\echo "api_server_1.2.7"

INSERT INTO k8s_policy_results (resource_id, execution_time, framework, check_id, title, context, namespace,
                                resource_name, status)
select uid                              AS resource_id,
        :'execution_time'::timestamp     AS execution_time,
        :'framework'                     AS framework,
        'api_server_1.2.7'                      AS check_id,
        'Ensure that the --authorization-mode argument includes Node' AS title,
    context,
  	namespace,
  	name AS resource_name,
    case
      when 
      container ->> 'command' like '%authorization-mode=%' AND
      container ->> 'command' like '%authorization-mode=%Node%'
      then 'pass'
      else 'fail'
    end as status
from
  k8s_core_pods,
  jsonb_array_elements(spec_containers) as container
where 
	namespace = 'kube-system' and container ->> 'name' = 'kube-apiserver';


-- query 1.2.8
\echo "api_server_1.2.8"

INSERT INTO k8s_policy_results (resource_id, execution_time, framework, check_id, title, context, namespace,
                                resource_name, status)
select uid                              AS resource_id,
        :'execution_time'::timestamp     AS execution_time,
        :'framework'                     AS framework,
        'api_server_1.2.8'                      AS check_id,
        'Ensure that the --authorization-mode argument includes RBAC' AS title,
    context,
  	namespace,
  	name AS resource_name,
    case
      when 
        container ->> 'command' like '%authorization-mode=%' AND
      container ->> 'command' like '%authorization-mode=%RBAC%'
      then 'pass'
      else 'fail'
  end as status
from
  k8s_core_pods,
  jsonb_array_elements(spec_containers) as container
where 
	namespace = 'kube-system' and container ->> 'name' = 'kube-apiserver';


-- query 1.2.9
\echo "api_server_1.2.9"

INSERT INTO k8s_policy_results (resource_id, execution_time, framework, check_id, title, context, namespace,
                                resource_name, status)
select uid                              AS resource_id,
        :'execution_time'::timestamp     AS execution_time,
        :'framework'                     AS framework,
        'api_server_1.2.9'                      AS check_id,
        'Ensure that the admission control plugin EventRateLimit is set' AS title,
    context,
  	namespace,
  	name AS resource_name,
    case
      when 
        container ->> 'command' like '%enable-admission-plugins=%' AND
      container ->> 'command' like '%enable-admission-plugins=%EventRateLimit%'
      then 'pass'
      else 'fail'
  end as status
from
  k8s_core_pods,
  jsonb_array_elements(spec_containers) as container
where 
	namespace = 'kube-system' and container ->> 'name' = 'kube-apiserver';


-- query 1.2.10
\echo "api_server_1.2.10"

INSERT INTO k8s_policy_results (resource_id, execution_time, framework, check_id, title, context, namespace,
                                resource_name, status)
select uid                              AS resource_id,
        :'execution_time'::timestamp     AS execution_time,
        :'framework'                     AS framework,
        'api_server_1.2.10'                      AS check_id,
        'Ensure that the admission control plugin AlwaysAdmit is not set' AS title,
    context,
  	namespace,
  	name AS resource_name,
    case
      when 
        container ->> 'command' like '%enable-admission-plugins=%' AND
      container ->> 'command' not like '%enable-admission-plugins=%AlwaysAdmit%'
      then 'pass'
      else 'fail'
    end as status
from
  k8s_core_pods,
  jsonb_array_elements(spec_containers) as container
where 
	namespace = 'kube-system' and container ->> 'name' = 'kube-apiserver';


-- query 1.2.11
\echo "api_server_1.2.11"

INSERT INTO k8s_policy_results (resource_id, execution_time, framework, check_id, title, context, namespace,
                                resource_name, status)
select uid                              AS resource_id,
        :'execution_time'::timestamp     AS execution_time,
        :'framework'                     AS framework,
        'api_server_1.2.11'                      AS check_id,
        'Ensure that the admission control plugin AlwaysPullImages is set' AS title,
    context,
  	namespace,
  	name AS resource_name,
    case
      when 
        container ->> 'command' like '%enable-admission-plugins=%' AND
      container ->> 'command' like '%enable-admission-plugins=%AlwaysPullImages%'
      then 'pass'
      else 'fail'
    end as status
from
  k8s_core_pods,
  jsonb_array_elements(spec_containers) as container
where 
	namespace = 'kube-system' and container ->> 'name' = 'kube-apiserver';


-- query 1.2.12
\echo "api_server_1.2.12"

INSERT INTO k8s_policy_results (resource_id, execution_time, framework, check_id, title, context, namespace,
                                resource_name, status)
select uid                              AS resource_id,
        :'execution_time'::timestamp     AS execution_time,
        :'framework'                     AS framework,
        'api_server_1.2.12'                      AS check_id,
        'Ensure that the admission control plugin SecurityContextDeny is set if PodSecurityPolicy is not used' AS title,
    context,
  	namespace,
  	name AS resource_name,
    case
      when 
        container ->> 'command' like '%enable-admission-plugins=%' AND
        container ->> 'command' like '%enable-admission-plugins=%PodSecurityPolicy%' AND
      container ->> 'command' not like '%enable-admission-plugins=%SecurityContextDeny%'
      then 'fail'
      else 'pass'
    end as status
from
  k8s_core_pods,
  jsonb_array_elements(spec_containers) as container
where 
	namespace = 'kube-system' and container ->> 'name' = 'kube-apiserver';


-- query 1.2.13
\echo "api_server_1.2.13"

INSERT INTO k8s_policy_results (resource_id, execution_time, framework, check_id, title, context, namespace,
                                resource_name, status)
select uid                              AS resource_id,
        :'execution_time'::timestamp     AS execution_time,
        :'framework'                     AS framework,
        'api_server_1.2.13'                      AS check_id,
        'Ensure that the admission control plugin ServiceAccount is set' AS title,
    context,
  	namespace,
  	name AS resource_name,
   case
      when 
        container ->> 'command' like '%enable-admission-plugins=%' AND
      container ->> 'command' not like '%enable-admission-plugins=%ServiceAccount%'
      then 'pass'
      else 'fail'
    end as status
from
  k8s_core_pods,
  jsonb_array_elements(spec_containers) as container
where 
	namespace = 'kube-system' and container ->> 'name' = 'kube-apiserver';

-- query 1.2.14
\echo "api_server_1.2.14"

INSERT INTO k8s_policy_results (resource_id, execution_time, framework, check_id, title, context, namespace,
                                resource_name, status)
select uid                              AS resource_id,
        :'execution_time'::timestamp     AS execution_time,
        :'framework'                     AS framework,
        'api_server_1.2.14'                      AS check_id,
        'Ensure that the admission control plugin NamespaceLifecycle is set' AS title,
    context,
  	namespace,
  	name AS resource_name,
   case
      when 
        container ->> 'command' like '%enable-admission-plugins=%' AND
      container ->> 'command' not like '%enable-admission-plugins=%NamespaceLifecycle%'
      then 'pass'
      else 'fail'
    end as status
from
  k8s_core_pods,
  jsonb_array_elements(spec_containers) as container
where 
	namespace = 'kube-system' and container ->> 'name' = 'kube-apiserver';

-- query 1.2.15
\echo "api_server_1.2.15"

INSERT INTO k8s_policy_results (resource_id, execution_time, framework, check_id, title, context, namespace,
                                resource_name, status)
select uid                              AS resource_id,
        :'execution_time'::timestamp     AS execution_time,
        :'framework'                     AS framework,
        'api_server_1.2.15'                      AS check_id,
        'Ensure that the admission control plugin NodeRestriction is set' AS title,
    context,
  	namespace,
  	name AS resource_name,
    case
      when 
        container ->> 'command' like '%enable-admission-plugins=%' AND
      container ->> 'command' like '%enable-admission-plugins=%NodeRestriction%'
      then 'pass'
      else 'fail'
    end as status
from
  k8s_core_pods,
  jsonb_array_elements(spec_containers) as container
where 
	namespace = 'kube-system' and container ->> 'name' = 'kube-apiserver';

-- query 1.2.16
\echo "api_server_1.2.16"

INSERT INTO k8s_policy_results (resource_id, execution_time, framework, check_id, title, context, namespace,
                                resource_name, status)
select uid                              AS resource_id,
        :'execution_time'::timestamp     AS execution_time,
        :'framework'                     AS framework,
        'api_server_1.2.16'                      AS check_id,
        'Ensure that the --secure-port argument is not set to 0' AS title,
    context,
  	namespace,
  	name AS resource_name,
    case 
        when 
        container ->> 'command' not like '%secure-port%' or
        CAST(REGEXP_REPLACE(container->>'command', '.*--secure-port=(\d+).*', '\1') AS INTEGER) BETWEEN 1 AND 65535 = true
        then 'pass'
        else 'fail'
    end as status
from
  k8s_core_pods,
  jsonb_array_elements(spec_containers) as container
where 
	namespace = 'kube-system' and container ->> 'name' = 'kube-apiserver';

-- query 1.2.17
\echo "api_server_1.2.17"

INSERT INTO k8s_policy_results (resource_id, execution_time, framework, check_id, title, context, namespace,
                                resource_name, status)
select uid                              AS resource_id,
        :'execution_time'::timestamp     AS execution_time,
        :'framework'                     AS framework,
        'api_server_1.2.17'                      AS check_id,
        'Ensure that the --profiling argument is set to false' AS title,
    context,
  	namespace,
  	name AS resource_name,
    case
      when 
        container ->> 'command' like '%profiling=false%'
      then 'pass'
      else 'fail'
    end as status
from
  k8s_core_pods,
  jsonb_array_elements(spec_containers) as container
where 
	namespace = 'kube-system' and container ->> 'name' = 'kube-apiserver';

-- query 1.2.18
\echo "api_server_1.2.18"

INSERT INTO k8s_policy_results (resource_id, execution_time, framework, check_id, title, context, namespace,
                                resource_name, status)
select uid                              AS resource_id,
        :'execution_time'::timestamp     AS execution_time,
        :'framework'                     AS framework,
        'api_server_1.2.18'                      AS check_id,
        'Ensure that the --audit-log-path argument is set' AS title,
    context,
  	namespace,
  	name AS resource_name,
    case
      when 
        container ->> 'command' like '%audit-log-path%'
      then 'pass'
      else 'fail'
    end as status
from
  k8s_core_pods,
  jsonb_array_elements(spec_containers) as container
where 
	namespace = 'kube-system' and container ->> 'name' = 'kube-apiserver';

-- query 1.2.19
\echo "api_server_1.2.19"

INSERT INTO k8s_policy_results (resource_id, execution_time, framework, check_id, title, context, namespace,
                                resource_name, status)
select uid                              AS resource_id,
        :'execution_time'::timestamp     AS execution_time,
        :'framework'                     AS framework,
        'api_server_1.2.19'                      AS check_id,
        'Ensure that the --audit-log-maxage argument is set to 30 or as appropriate' AS title,
    context,
  	namespace,
  	name AS resource_name,
    case 
		  when 
        container ->> 'command' like '%audit-log-maxage%' and
        CAST(REGEXP_REPLACE(container->>'command', '.*--audit-log-maxage=(\d+).*', '\1') AS INTEGER) < 30
      then 'fail'
			else 'pass'
		end as status
from
  k8s_core_pods,
  jsonb_array_elements(spec_containers) as container
where 
	namespace = 'kube-system' and container ->> 'name' = 'kube-apiserver';

-- query 1.2.20
\echo "api_server_1.2.20"

INSERT INTO k8s_policy_results (resource_id, execution_time, framework, check_id, title, context, namespace,
                                resource_name, status)
select uid                              AS resource_id,
        :'execution_time'::timestamp     AS execution_time,
        :'framework'                     AS framework,
        'api_server_1.2.20'                      AS check_id,
        'Ensure that the --audit-log-maxbackup argument is set to 10 or as appropriate' AS title,
    context,
  	namespace,
  	name AS resource_name,
    case 
		  when 
        container ->> 'command' like '%audit-log-maxbackup%' and
        CAST(REGEXP_REPLACE(container->>'command', '.*--audit-log-maxbackup=(\d+).*', '\1') AS INTEGER) < 10
      then 'fail'
			else 'pass'
		end as status
from
  k8s_core_pods,
  jsonb_array_elements(spec_containers) as container
where 
	namespace = 'kube-system' and container ->> 'name' = 'kube-apiserver';

-- query 1.2.21
\echo "api_server_1.2.21"

INSERT INTO k8s_policy_results (resource_id, execution_time, framework, check_id, title, context, namespace,
                                resource_name, status)
select uid                              AS resource_id,
        :'execution_time'::timestamp     AS execution_time,
        :'framework'                     AS framework,
        'api_server_1.2.21'                      AS check_id,
        'Ensure that the --audit-log-maxsize argument is set to 100 or as appropriate' AS title,
    context,
  	namespace,
  	name AS resource_name,
    case 
      when 
        container ->> 'command' like '%audit-log-maxsize%' and
        CAST(REGEXP_REPLACE(container->>'command', '.*--audit-log-maxsize=(\d+).*', '\1') AS INTEGER) < 100
      then 'fail'
      else 'pass'
    end as status
from
  k8s_core_pods,
  jsonb_array_elements(spec_containers) as container
where 
	namespace = 'kube-system' and container ->> 'name' = 'kube-apiserver';

-- query 1.2.22
\echo "api_server_1.2.22"

INSERT INTO k8s_policy_results (resource_id, execution_time, framework, check_id, title, context, namespace,
                                resource_name, status)
select uid                              AS resource_id,
        :'execution_time'::timestamp     AS execution_time,
        :'framework'                     AS framework,
        'api_server_1.2.22'                      AS check_id,
        'Ensure that the --request-timeout argument is set as appropriate' AS title,
    context,
  	namespace,
  	name AS resource_name,
    case
        when 
          container ->> 'command' not like '%request-timeout=0%'
        then 'pass'
        else 'fail'
    end as status
from
  k8s_core_pods,
  jsonb_array_elements(spec_containers) as container
where 
	namespace = 'kube-system' and container ->> 'name' = 'kube-apiserver';

-- query 1.2.23
\echo "api_server_1.2.23"

INSERT INTO k8s_policy_results (resource_id, execution_time, framework, check_id, title, context, namespace,
                                resource_name, status)
select uid                              AS resource_id,
        :'execution_time'::timestamp     AS execution_time,
        :'framework'                     AS framework,
        'api_server_1.2.23'                      AS check_id,
        'Ensure that the --service-account-lookup argument is set to true' AS title,
    context,
  	namespace,
  	name AS resource_name,
    case
      when 
        container ->> 'command' like '%service-account-lookup=true%'
      then 'fail'
      else 'pass'
    end as status
from
  k8s_core_pods,
  jsonb_array_elements(spec_containers) as container
where 
	namespace = 'kube-system' and container ->> 'name' = 'kube-apiserver';

-- query 1.2.24
\echo "api_server_1.2.24"

INSERT INTO k8s_policy_results (resource_id, execution_time, framework, check_id, title, context, namespace,
                                resource_name, status)
select uid                              AS resource_id,
        :'execution_time'::timestamp     AS execution_time,
        :'framework'                     AS framework,
        'api_server_1.2.24'                      AS check_id,
        'Ensure that the --service-account-key-file argument is set as appropriate' AS title,
    context,
  	namespace,
  	name AS resource_name,
    case
      when 
        container ->> 'command' like '%service-account-key-file%'
      then 'fail'
      else 'pass'
    end as status
from
  k8s_core_pods,
  jsonb_array_elements(spec_containers) as container
where 
	namespace = 'kube-system' and container ->> 'name' = 'kube-apiserver';

-- query 1.2.25
\echo "api_server_1.2.25"

INSERT INTO k8s_policy_results (resource_id, execution_time, framework, check_id, title, context, namespace,
                                resource_name, status)
select uid                              AS resource_id,
        :'execution_time'::timestamp     AS execution_time,
        :'framework'                     AS framework,
        'api_server_1.2.25'                      AS check_id,
        'Ensure that the --etcd-certfile and --etcd-keyfile arguments are set as appropriate' AS title,
    context,
  	namespace,
  	name AS resource_name,
    case
      when 
        container ->> 'command' like '%etcd-certfile%' and
        container ->> 'command' like '%etcd-keyfile%'
      then 'pass'
      else 'fail'
    end as status
from
  k8s_core_pods,
  jsonb_array_elements(spec_containers) as container
where 
	namespace = 'kube-system' and container ->> 'name' = 'kube-apiserver';

-- query 1.2.26
\echo "api_server_1.2.26"

INSERT INTO k8s_policy_results (resource_id, execution_time, framework, check_id, title, context, namespace,
                                resource_name, status)
select uid                              AS resource_id,
        :'execution_time'::timestamp     AS execution_time,
        :'framework'                     AS framework,
        'api_server_1.2.26'                      AS check_id,
        'Ensure that the --tls-cert-file and --tls-private-key-file arguments are set as appropriate' AS title,
    context,
  	namespace,
  	name AS resource_name,
    case
      when 
        container ->> 'command' like '%tls-cert-file%' and
        container ->> 'command' like '%tls-private-key-file%'
      then 'pass'
      else 'fail'
    end as status
from
  k8s_core_pods,
  jsonb_array_elements(spec_containers) as container
where 
	namespace = 'kube-system' and container ->> 'name' = 'kube-apiserver';

-- query 1.2.27
\echo "api_server_1.2.27"

INSERT INTO k8s_policy_results (resource_id, execution_time, framework, check_id, title, context, namespace,
                                resource_name, status)
select uid                              AS resource_id,
        :'execution_time'::timestamp     AS execution_time,
        :'framework'                     AS framework,
        'api_server_1.2.27'                      AS check_id,
        'Ensure that the --client-ca-file argument is set as appropriate' AS title,
    context,
  	namespace,
  	name AS resource_name,
    case
      when 
        container ->> 'command' like '%client-ca-file%'
      then 'pass'
      else 'fail'
    end as status
from
  k8s_core_pods,
  jsonb_array_elements(spec_containers) as container
where 
	namespace = 'kube-system' and container ->> 'name' = 'kube-apiserver';

-- query 1.2.28
\echo "api_server_1.2.28"

INSERT INTO k8s_policy_results (resource_id, execution_time, framework, check_id, title, context, namespace,
                                resource_name, status)
select uid                              AS resource_id,
        :'execution_time'::timestamp     AS execution_time,
        :'framework'                     AS framework,
        'api_server_1.2.28'                      AS check_id,
        'Ensure that the --etcd-cafile argument is set as appropriate' AS title,
    context,
  	namespace,
  	name AS resource_name,
    case
      when 
        container ->> 'command' like '%etcd-cafile%'
      then 'pass'
      else 'fail'
    end as status
from
  k8s_core_pods,
  jsonb_array_elements(spec_containers) as container
where 
	namespace = 'kube-system' and container ->> 'name' = 'kube-apiserver';

-- query 1.2.29
\echo "api_server_1.2.29"

INSERT INTO k8s_policy_results (resource_id, execution_time, framework, check_id, title, context, namespace,
                                resource_name, status)
select uid                              AS resource_id,
        :'execution_time'::timestamp     AS execution_time,
        :'framework'                     AS framework,
        'api_server_1.2.29'                      AS check_id,
        'Ensure that the --encryption-provider-config argument is set as appropriate' AS title,
    context,
  	namespace,
  	name AS resource_name,
    case
      when 
        container ->> 'command' like '%encryption-provider-config%'
      then 'pass'
      else 'fail'
    end as status
from
  k8s_core_pods,
  jsonb_array_elements(spec_containers) as container
where 
	namespace = 'kube-system' and container ->> 'name' = 'kube-apiserver';

-- query 1.2.30
\echo "api_server_1.2.30"

INSERT INTO k8s_policy_results (resource_id, execution_time, framework, check_id, title, context, namespace,
                                resource_name, status)
select uid                              AS resource_id,
        :'execution_time'::timestamp     AS execution_time,
        :'framework'                     AS framework,
        'api_server_1.2.30'                      AS check_id,
        'Ensure that encryption providers are appropriately configured' AS title,
    context,
  	namespace,
  	name AS resource_name,
    case
      when 
        container ->> 'command' like '%encryption-provider-config%'
      then 'pass'
      else 'fail'
    end as status
from
  k8s_core_pods,
  jsonb_array_elements(spec_containers) as container
where 
	namespace = 'kube-system' and container ->> 'name' = 'kube-apiserver';

-- query 1.2.31
\echo "api_server_1.2.31"

INSERT INTO k8s_policy_results (resource_id, execution_time, framework, check_id, title, context, namespace,
                                resource_name, status)
select uid                              AS resource_id,
        :'execution_time'::timestamp     AS execution_time,
        :'framework'                     AS framework,
        'api_server_1.2.31'                      AS check_id,
        'Ensure that the API Server only makes use of Strong Cryptographic Ciphers' AS title,
    context,
  	namespace,
  	name AS resource_name,
    case
      when 
        container ->> 'command' ~
        '.*TLS_AES_128_GCM_SHA256.*'
        '.*TLS_AES_256_GCM_SHA384.*'
        '.*TLS_CHACHA20_POLY1305_SHA256.*'
        '.*TLS_ECDHE_ECDSA_WITH_AES_128_CBC_SHA.*'
        '.*TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256.*'
        '.*TLS_ECDHE_ECDSA_WITH_AES_256_CBC_SHA.*'
        '.*TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384.*'
        '.*TLS_ECDHE_ECDSA_WITH_CHACHA20_POLY1305.*'
        '.*TLS_ECDHE_ECDSA_WITH_CHACHA20_POLY1305_SHA256.*'
        '.*TLS_ECDHE_RSA_WITH_3DES_EDE_CBC_SHA.*'
        '.*TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA.*'
        '.*TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256.*'
        '.*TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA.*'
        '.*TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384.*'
        '.*TLS_ECDHE_RSA_WITH_CHACHA20_POLY1305.*'
        '.*TLS_ECDHE_RSA_WITH_CHACHA20_POLY1305_SHA256.*'
        '.*TLS_RSA_WITH_3DES_EDE_CBC_SHA.*'
        '.*TLS_RSA_WITH_AES_128_CBC_SHA.*'
        '.*TLS_RSA_WITH_AES_128_GCM_SHA256.*'
        '.*TLS_RSA_WITH_AES_256_CBC_SHA.*'
        '.*TLS_RSA_WITH_AES_256_GCM_SHA384.*'
        '.*'
      then 'pass'
      else 'fail'
    end as status
from
  k8s_core_pods,
  jsonb_array_elements(spec_containers) as container
where 
	namespace = 'kube-system' and container ->> 'name' = 'kube-apiserver';
