{% macro api_server_1_2_23(framework, check_id) %}
select uid                              AS resource_id,
        '{{framework}}' As framework,
        '{{check_id}}'  As check_id,
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
	namespace = 'kube-system' and container ->> 'name' = 'kube-apiserver'


{% endmacro %}