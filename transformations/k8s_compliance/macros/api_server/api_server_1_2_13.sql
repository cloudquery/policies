{% macro api_server_1_2_13(framework, check_id) %}
select uid                              AS resource_id,
        '{{framework}}' As framework,
        '{{check_id}}'  As check_id,
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
	namespace = 'kube-system' and container ->> 'name' = 'kube-apiserver'


{% endmacro %}