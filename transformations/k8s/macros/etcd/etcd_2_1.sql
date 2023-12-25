{% macro etcd_2_1(framework, check_id) %}
  {{ return(adapter.dispatch('etcd_2_1')(framework, check_id)) }}
{% endmacro %}

{% macro default__etcd_2_1(framework, check_id) %}{% endmacro %}

{% macro postgres__etcd_2_1(framework, check_id) %}
select uid                              AS resource_id,
        '{{framework}}' As framework,
        '{{check_id}}'  As check_id,
        'Ensure that the --cert-file and --key-file arguments are set as appropriate' AS title,
        context,
  	namespace,
  	name AS resource_name,
    case 
		when 
			container ->> 'command' like '%cert-file%' and container ->> 'command' like '%key-file%'
			then 'pass'
			else 'fail'
		end as status
from
  k8s_core_pods,
  jsonb_array_elements(spec_containers) as container
where 
	namespace = 'kube-system' and container ->> 'name' = 'etcd'
{% endmacro %}

{% macro snowflake__etcd_2_1(framework, check_id) %}
select uid                              AS resource_id,
        '{{framework}}' As framework,
        '{{check_id}}'  As check_id,
        'Ensure that the --cert-file and --key-file arguments are set as appropriate' AS title,
        context,
  	namespace,
  	name AS resource_name,
    case 
		when 
			container.value:command like '%cert-file%' and container.value:command like '%key-file%'
			then 'pass'
			else 'fail'
		end as status
from
  k8s_core_pods,
  LATERAL FLATTEN(spec_containers) AS container
where 
	namespace = 'kube-system' and container.value:name = 'etcd'
{% endmacro %}

{% macro bigquery__etcd_2_1(framework, check_id) %}

{% endmacro %}