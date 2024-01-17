{% macro api_server_1_2_6(framework, check_id) %}
  {{ return(adapter.dispatch('api_server_1_2_6')(framework, check_id)) }}
{% endmacro %}

{% macro default__api_server_1_2_6(framework, check_id) %}{% endmacro %}

{% macro postgres__api_server_1_2_6(framework, check_id) %}
select uid                              AS resource_id,
        '{{framework}}' As framework,
        '{{check_id}}'  As check_id,
        'Ensure that the --authorization-mode argument is not set to AlwaysAllow' AS title,
    context,
  	namespace,
  	name AS resource_name,
    case
      when 
        container ->> 'command' like '%authorization-mode=%' AND
      container ->> 'command' not like '%authorization-mode=%AlwaysAllow%'
      then 'pass'
      else 'fail'
    end as status
from
  k8s_core_pods,
  jsonb_array_elements(spec_containers) as container
where 
	namespace = 'kube-system' and container ->> 'name' = 'kube-apiserver'
{% endmacro %}

{% macro snowflake__api_server_1_2_6(framework, check_id) %}
select uid                              AS resource_id,
        '{{framework}}' As framework,
        '{{check_id}}'  As check_id,
        'Ensure that the --authorization-mode argument is not set to AlwaysAllow' AS title,
    context,
  	namespace,
  	name AS resource_name,
    case
      when 
        container.value:command like '%authorization-mode=%' AND
      container.value:command not like '%authorization-mode=%AlwaysAllow%'
      then 'pass'
      else 'fail'
    end as status
from
  k8s_core_pods,
  LATERAL FLATTEN(spec_containers) container
where 
	namespace = 'kube-system' and container.value:name = 'kube-apiserver'
{% endmacro %}

{% macro bigquery__api_server_1_2_6(framework, check_id) %}

{% endmacro %}