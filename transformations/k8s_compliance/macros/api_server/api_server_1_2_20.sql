{% macro api_server_1_2_20(framework, check_id) %}
select uid                              AS resource_id,
        '{{framework}}' As framework,
        '{{check_id}}'  As check_id,
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
	namespace = 'kube-system' and container ->> 'name' = 'kube-apiserver'


{% endmacro %}