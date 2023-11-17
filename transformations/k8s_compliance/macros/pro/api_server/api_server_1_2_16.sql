{% macro api_server_1_2_16(framework, check_id) %}
select uid                              AS resource_id,
        '{{framework}}' As framework,
        '{{check_id}}'  As check_id,
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
	namespace = 'kube-system' and container ->> 'name' = 'kube-apiserver'


{% endmacro %}