{% macro api_server_1_2_25(framework, check_id) %}
select uid                              AS resource_id,
        '{{framework}}' As framework,
        '{{check_id}}'  As check_id,
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
	namespace = 'kube-system' and container ->> 'name' = 'kube-apiserver'


{% endmacro %}