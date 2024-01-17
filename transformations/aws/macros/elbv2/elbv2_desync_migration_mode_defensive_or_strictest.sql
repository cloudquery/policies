{% macro elbv2_desync_migration_mode_defensive_or_strictest(framework, check_id) %}
  {{ return(adapter.dispatch('elbv2_desync_migration_mode_defensive_or_strictest')(framework, check_id)) }}
{% endmacro %}

{% macro default__elbv2_desync_migration_mode_defensive_or_strictest(framework, check_id) %}{% endmacro %}

{% macro postgres__elbv2_desync_migration_mode_defensive_or_strictest(framework, check_id) %}
select
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
'Application Load Balancer should be configured with defensive or strictest desync mitigation mode' as title,
  account_id,
  load_balancer_arn as resource_id,
  case
        WHEN value in ('defensive', 'strictest') THEN 'pass'
        ELSE 'fail'
  END as status
from aws_elbv2_load_balancer_attributes
where key = 'routing.http.desync_mitigation_mode'
{% endmacro %}

{% macro snowflake__elbv2_desync_migration_mode_defensive_or_strictest(framework, check_id) %}
select
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
'Application Load Balancer should be configured with defensive or strictest desync mitigation mode' as title,
  account_id,
  load_balancer_arn as resource_id,
  case
        WHEN value in ('defensive', 'strictest') THEN 'pass'
        ELSE 'fail'
  END as status
from aws_elbv2_load_balancer_attributes
where key = 'routing.http.desync_mitigation_mode'
{% endmacro %}