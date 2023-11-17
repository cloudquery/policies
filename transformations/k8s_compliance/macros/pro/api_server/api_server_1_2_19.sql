{% macro api_server_1_2_19(framework, check_id) %}
select uid                              AS resource_id,
        '{{framework}}' As framework,
        '{{check_id}}'  As check_id,
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
	namespace = 'kube-system' and container ->> 'name' = 'kube-apiserver'


{% endmacro %}