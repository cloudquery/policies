{% macro scheduler_1_4_1(framework, check_id) %}
  {{ return(adapter.dispatch('scheduler_1_4_1')(framework, check_id)) }}
{% endmacro %}

{% macro default__scheduler_1_4_1(framework, check_id) %}{% endmacro %}

{% macro postgres__scheduler_1_4_1(framework, check_id) %}
select uid                              AS resource_id,
        '{{framework}}' As framework,
        '{{check_id}}'  As check_id,
        'Ensure that the --profiling argument is set to false' AS title,
        context,
  	namespace,
  	name AS resource_name,
    case 
		when 
			container ->> 'command' like '%profiling=false%'
			then 'pass'
			else 'fail'
		end as status
from
  k8s_core_pods,
  jsonb_array_elements(spec_containers) as container
where 
	namespace = 'kube-system' and container ->> 'name' = 'kube-scheduler'
{% endmacro %}

{% macro snowflake__scheduler_1_4_1(framework, check_id) %}
select uid                              AS resource_id,
        '{{framework}}' As framework,
        '{{check_id}}'  As check_id,
        'Ensure that the --profiling argument is set to false' AS title,
        context,
  	namespace,
  	name AS resource_name,
    case 
		when 
			container.value:command like '%profiling=false%'
			then 'pass'
			else 'fail'
		end as status
from
  k8s_core_pods,
  LATERAL FLATTEN(spec_containers) AS container
where 
	namespace = 'kube-system' and container.value:name = 'kube-scheduler'
{% endmacro %}

{% macro bigquery__scheduler_1_4_1(framework, check_id) %}

{% endmacro %}