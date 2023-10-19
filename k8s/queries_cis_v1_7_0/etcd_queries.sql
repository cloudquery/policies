-- query 2.1
\echo "etcd_2.1"

INSERT INTO k8s_policy_results (resource_id, execution_time, framework, check_id, title, context, namespace,
                                resource_name, status)
select uid                              AS resource_id,
        :'execution_time'::timestamp     AS execution_time,
        :'framework'                     AS framework,
        'etcd_2.1'                      AS check_id,
        'Ensure that the --cert-file and --key-file arguments are set as appropriate' AS title,
        context,
  	namespace,
  	name AS resource_name,
    case 
		when 
			container ->> 'command' like '%cert-file%' and container ->> 'command' like '%key-file%'
			then 'pass'
			else 'fail'
		end as status
from
  k8s_core_pods,
  jsonb_array_elements(spec_containers) as container
where 
	namespace = 'kube-system' and container ->> 'name' = 'etcd';

-- query 2.2
\echo "etcd_2.2"

INSERT INTO k8s_policy_results (resource_id, execution_time, framework, check_id, title, context, namespace,
                                resource_name, status)
select uid                              AS resource_id,
        :'execution_time'::timestamp     AS execution_time,
        :'framework'                     AS framework,
        'etcd_2.2'                      AS check_id,
        'Ensure that the --client-cert-auth argument is set to true' AS title,
        context,
  	namespace,
  	name AS resource_name,
    case 
      when 
        container ->> 'command' like '%client-cert-auth=true%'
        then 'pass'
        else 'fail'
    end as status
from
  k8s_core_pods,
  jsonb_array_elements(spec_containers) as container
where 
	namespace = 'kube-system' and container ->> 'name' = 'etcd';

-- query 2.3
\echo "etcd_2.3"

INSERT INTO k8s_policy_results (resource_id, execution_time, framework, check_id, title, context, namespace,
                                resource_name, status)
select uid                              AS resource_id,
        :'execution_time'::timestamp     AS execution_time,
        :'framework'                     AS framework,
        'etcd_2.3'                      AS check_id,
        'Ensure that the --auto-tls argument is not set to true' AS title,
        context,
  	namespace,
  	name AS resource_name,
    case 
        when 
          container ->> 'command' like '%auto-tls%' and container ->> 'command' not like '%auto-tls=false%'
          then 'fail'
          else 'pass'
    end as status
from
  k8s_core_pods,
  jsonb_array_elements(spec_containers) as container
where 
	namespace = 'kube-system' and container ->> 'name' = 'etcd';

-- query 2.4
\echo "etcd_2.4"

INSERT INTO k8s_policy_results (resource_id, execution_time, framework, check_id, title, context, namespace,
                                resource_name, status)
select uid                              AS resource_id,
        :'execution_time'::timestamp     AS execution_time,
        :'framework'                     AS framework,
        'etcd_2.4'                      AS check_id,
        'Ensure that the --peer-cert-file and --peer-key-file arguments are set as appropriate' AS title,
        context,
  	namespace,
  	name AS resource_name,
    case 
      when 
        container ->> 'command' like '%peer-cert-file%' and container ->> 'command' like '%peer-key-file%'
        then 'pass'
        else 'fail'
		end as status
from
  k8s_core_pods,
  jsonb_array_elements(spec_containers) as container
where 
	namespace = 'kube-system' and container ->> 'name' = 'etcd';

-- query 2.5
\echo "etcd_2.5"

INSERT INTO k8s_policy_results (resource_id, execution_time, framework, check_id, title, context, namespace,
                                resource_name, status)
select uid                              AS resource_id,
        :'execution_time'::timestamp     AS execution_time,
        :'framework'                     AS framework,
        'etcd_2.5'                      AS check_id,
        'Ensure that the --peer-client-cert-auth argument is set to true' AS title,
        context,
  	namespace,
  	name AS resource_name,
    case 
      when 
        container ->> 'command' like '%peer-client-cert-auth=true%'
        then 'pass'
        else 'fail'
		end as status
from
  k8s_core_pods,
  jsonb_array_elements(spec_containers) as container
where 
	namespace = 'kube-system' and container ->> 'name' = 'etcd';

-- query 2.6
\echo "etcd_2.6"

INSERT INTO k8s_policy_results (resource_id, execution_time, framework, check_id, title, context, namespace,
                                resource_name, status)
select uid                              AS resource_id,
        :'execution_time'::timestamp     AS execution_time,
        :'framework'                     AS framework,
        'etcd_2.6'                      AS check_id,
        'Ensure that the --peer-auto-tls argument is not set to true' AS title,
        context,
  	namespace,
  	name AS resource_name,
    case 
      when 
        container ->> 'command' like '%peer-auto-tls%' and container ->> 'command' not like '%peer-auto-tls=false%'
        then 'fail'
        else 'pass'
		end as status
from
  k8s_core_pods,
  jsonb_array_elements(spec_containers) as container
where 
	namespace = 'kube-system' and container ->> 'name' = 'etcd';