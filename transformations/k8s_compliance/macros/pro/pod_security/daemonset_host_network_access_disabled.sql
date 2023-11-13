{% macro daemonset_host_network_access_disabled(framework, check_id) %}
  {{ return(adapter.dispatch('daemonset_host_network_access_disabled')(framework, check_id)) }}
{% endmacro %}

{% macro default__daemonset_host_network_access_disabled(framework, check_id) %}{% endmacro %}

{% macro postgres__daemonset_host_network_access_disabled(framework, check_id) %}
select uid                                        AS resource_id,
       '{{framework}}'                               AS framework,
       '{{check_id}}'                                AS check_id,
       'Deamonset container hostNetwork disabled' AS title,
       context                                    AS context,
       namespace                                  AS namespace,
       name                                       AS resource_name,
       CASE
           WHEN
               spec_template -> 'spec' ->> 'hostNetwork' = 'true'
               THEN 'fail'
           ELSE 'pass'
           END                                    AS status
FROM k8s_apps_daemon_sets
{% endmacro %}
