{% macro etcd_2_3(framework, check_id) %}
select uid                              AS resource_id,
        '{{framework}}' As framework,
        '{{check_id}}'  As check_id,
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
	namespace = 'kube-system' and container ->> 'name' = 'etcd'


{% endmacro %}