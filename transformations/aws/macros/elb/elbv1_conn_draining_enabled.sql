{% macro elbv1_conn_draining_enabled(framework, check_id) %}
  {{ return(adapter.dispatch('elbv1_conn_draining_enabled')(framework, check_id)) }}
{% endmacro %}

{% macro snowflake__elbv1_conn_draining_enabled(framework, check_id) %}
select
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'Classic Load Balancers should have connection draining enabled' as title,
  account_id,
  arn as resource_id,
  case when
    (attributes:ConnectionDraining:Enabled)::boolean is distinct from true
    then 'fail'
    else 'pass'
  end as status
from
    aws_elbv1_load_balancers
{% endmacro %}

{% macro postgres__elbv1_conn_draining_enabled(framework, check_id) %}
select
  '{{framework}}' as framework,
  '{{check_id}}' as check_id,
  'Classic Load Balancers should have connection draining enabled' as title,
  account_id,
  arn as resource_id,
  case when
    (attributes->'ConnectionDraining'->>'Enabled')::boolean is not true
    then 'fail'
    else 'pass'
  end as status
from
    aws_elbv1_load_balancers
{% endmacro %}

{% macro default__elbv1_conn_draining_enabled(framework, check_id) %}{% endmacro %}

{% macro bigquery__elbv1_conn_draining_enabled(framework, check_id) %}
select
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'Classic Load Balancers should have connection draining enabled' as title,
  account_id,
  arn as resource_id,
  case when
    CAST( JSON_VALUE(attributes.ConnectionDraining.Enabled) AS BOOL) is distinct from true
    then 'fail'
    else 'pass'
  end as status
from
    {{ full_table_name("aws_elbv1_load_balancers") }}
{% endmacro %}

{% macro athena__elbv1_conn_draining_enabled(framework, check_id) %}
select
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'Classic Load Balancers should have connection draining enabled' as title,
  account_id,
  arn as resource_id,
  case when
    cast(json_extract_scalar(attributes, '$.ConnectionDraining.Enabled') as boolean) is distinct from true
    then 'fail'
    else 'pass'
  end as status
from
    aws_elbv1_load_balancers
{% endmacro %}