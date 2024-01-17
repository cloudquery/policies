{% macro scheduler_1_4_2(framework, check_id) %}
  {{ return(adapter.dispatch('scheduler_1_4_2')(framework, check_id)) }}
{% endmacro %}

{% macro default__scheduler_1_4_2(framework, check_id) %}{% endmacro %}

{% macro postgres__scheduler_1_4_2(framework, check_id) %}
select uid                              AS resource_id,
        '{{framework}}' As framework,
        '{{check_id}}'  As check_id,
        'Ensure that the --bind-address argument is set to 127.0.0.1' AS title,
        context,
  	namespace,
  	name AS resource_name,
    case 
		when 
			container ->> 'command' like '%bind-address=127.0.0.1%' or container ->> 'command' not like '%bind-address%'
			then 'pass'
			else 'fail'
		end as status
from
  k8s_core_pods,
  jsonb_array_elements(spec_containers) as container
where 
	namespace = 'kube-system' and container ->> 'name' = 'kube-scheduler'
{% endmacro %}

{% macro snowflake__scheduler_1_4_2(framework, check_id) %}
select uid                              AS resource_id,
        '{{framework}}' As framework,
        '{{check_id}}'  As check_id,
        'Ensure that the --bind-address argument is set to 127.0.0.1' AS title,
        context,
  	namespace,
  	name AS resource_name,
    case 
		when 
			container.value:command like '%bind-address=127.0.0.1%' or container.value:command not like '%bind-address%'
			then 'pass'
			else 'fail'
		end as status
from
  k8s_core_pods,
  LATERAL FLATTEN(spec_containers) AS container
where 
	namespace = 'kube-system' and container.value:name = 'kube-scheduler'
{% endmacro %}

{% macro bigquery__scheduler_1_4_2(framework, check_id) %}

{% endmacro %}