{% macro etcd_2_1(framework, check_id) %}
select uid                              AS resource_id,
        '{{framework}}' As framework,
        '{{check_id}}'  As check_id,
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
	namespace = 'kube-system' and container ->> 'name' = 'etcd'


{% endmacro %}