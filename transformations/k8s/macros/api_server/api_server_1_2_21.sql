{% macro api_server_1_2_21(framework, check_id) %}
  {{ return(adapter.dispatch('api_server_1_2_21')(framework, check_id)) }}
{% endmacro %}

{% macro default__api_server_1_2_21(framework, check_id) %}{% endmacro %}

{% macro postgres__api_server_1_2_21(framework, check_id) %}
select uid                              AS resource_id,
        '{{framework}}' As framework,
        '{{check_id}}'  As check_id,
        'Ensure that the --audit-log-maxsize argument is set to 100 or as appropriate' AS title,
    context,
  	namespace,
  	name AS resource_name,
    case 
      when 
        container ->> 'command' like '%audit-log-maxsize%' and
        CAST(REGEXP_REPLACE(container->>'command', '.*--audit-log-maxsize=(\d+).*', '\1') AS INTEGER) < 100
      then 'fail'
      else 'pass'
    end as status
from
  k8s_core_pods,
  jsonb_array_elements(spec_containers) as container
where 
	namespace = 'kube-system' and container ->> 'name' = 'kube-apiserver'
{% endmacro %}

{% macro snowflake__api_server_1_2_21(framework, check_id) %}
select uid                              AS resource_id,
        '{{framework}}' As framework,
        '{{check_id}}'  As check_id,
        'Ensure that the --audit-log-maxsize argument is set to 100 or as appropriate' AS title,
    context,
  	namespace,
  	name AS resource_name,
    case 
      when 
        container.value:command like '%audit-log-maxsize%' and
        CAST(REGEXP_REPLACE(container.value:command, '.*--audit-log-maxsize=(\d+).*', '\\1') AS INTEGER) < 100
      then 'fail'
      else 'pass'
    end as status
from
  k8s_core_pods,
  LATERAL FLATTEN(spec_containers) container
where 
	namespace = 'kube-system' and container.value:name = 'kube-apiserver'
{% endmacro %}

{% macro bigquery__api_server_1_2_21(framework, check_id) %}

{% endmacro %}