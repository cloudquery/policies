{% macro pod_security_standards_5_7_2(framework, check_id) %}
  {{ return(adapter.dispatch('pod_security_standards_5_7_2')(framework, check_id)) }}
{% endmacro %}

{% macro default__pod_security_standards_5_7_2(framework, check_id) %}{% endmacro %}

{% macro postgres__pod_security_standards_5_7_2(framework, check_id) %}
select
    uid                              AS resource_id,
        '{{framework}}' As framework,
        '{{check_id}}'  As check_id,
    'Ensure that the seccomp profile is set to docker/default in your pod definitions' AS title,
    context                          AS context,
    namespace                        AS namespace,
    name                             AS resource_name,
  CASE
  WHEN 
      spec_security_context->'seccompProfile' IS NULL
      OR
      NOT((spec_security_context)::text LIKE '%docker/default%')
  THEN 'fail'
  ELSE 'pass'
  END
    AS status
FROM
  k8s_core_pods
{% endmacro %}

{% macro snowflake__pod_security_standards_5_7_2(framework, check_id) %}
select
    uid                              AS resource_id,
        '{{framework}}' As framework,
        '{{check_id}}'  As check_id,
    'Ensure that the seccomp profile is set to docker/default in your pod definitions' AS title,
    context                          AS context,
    namespace                        AS namespace,
    name                             AS resource_name,
  CASE
  WHEN 
      spec_security_context:seccompProfile IS NULL
      OR
      NOT((spec_security_context)::text LIKE '%docker/default%')
  THEN 'fail'
  ELSE 'pass'
  END
    AS status
FROM
  k8s_core_pods
{% endmacro %}

{% macro bigquery__pod_security_standards_5_7_2(framework, check_id) %}

{% endmacro %}