{% macro etcd_2_2(framework, check_id) %}
select uid                              AS resource_id,
        '{{framework}}' As framework,
        '{{check_id}}'  As check_id,
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
	namespace = 'kube-system' and container ->> 'name' = 'etcd'


{% endmacro %}