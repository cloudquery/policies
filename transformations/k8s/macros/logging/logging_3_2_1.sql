{% macro logging_3_2_1(framework, check_id) %}
  {{ return(adapter.dispatch('logging_3_2_1')(framework, check_id)) }}
{% endmacro %}

{% macro default__logging_3_2_1(framework, check_id) %}{% endmacro %}

{% macro postgres__logging_3_2_1(framework, check_id) %}
select uid                              AS resource_id,
        '{{framework}}' As framework,
        '{{check_id}}'  As check_id,
        'Ensure that a minimal audit policy is created' AS title,
        context,
  	namespace,
  	name AS resource_name,
    case 
		when 
			container ->> 'command' like '%audit-policy-file%'
			then 'pass'
			else 'fail'
		end as status
from
  k8s_core_pods,
  jsonb_array_elements(spec_containers) as container
where 
	namespace = 'kube-system' and container ->> 'name' = 'kube-apiserver'
{% endmacro %}

{% macro snowflake__logging_3_2_1(framework, check_id) %}
select uid                              AS resource_id,
        '{{framework}}' As framework,
        '{{check_id}}'  As check_id,
        'Ensure that a minimal audit policy is created' AS title,
        context,
  	namespace,
  	name AS resource_name,
    case 
		when 
			container.value:command like '%audit-policy-file%'
			then 'pass'
			else 'fail'
		end as status
from
  k8s_core_pods,
  LATERAL FLATTEN(spec_containers) AS container
where 
	namespace = 'kube-system' and container.value:name = 'kube-apiserver'
{% endmacro %}

{% macro bigquery__logging_3_2_1(framework, check_id) %}

{% endmacro %}