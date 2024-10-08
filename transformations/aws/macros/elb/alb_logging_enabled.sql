{% macro alb_logging_enabled(framework, check_id) %}
  {{ return(adapter.dispatch('alb_logging_enabled')(framework, check_id)) }}
{% endmacro %}

{% macro snowflake__alb_logging_enabled(framework, check_id) %}

(select
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'Application and Classic Load Balancers logging should be enabled' as title,
  lb.account_id,
  lb.arn as resource_id,
  case when
    lb.type = 'application' and (a.value)::boolean is distinct from true -- TODO check
    then 'fail'
    else 'pass'
  end as status
  from aws_elbv2_load_balancers lb
    inner join
        aws_elbv2_load_balancer_attributes a on
            a.load_balancer_arn = lb.arn AND a.key='access_logs.s3.enabled')
union
(
    select
      '{{framework}}' As framework,
      '{{check_id}}' As check_id,
      'Application and Classic Load Balancers logging should be enabled' as title,
      account_id,
      arn as resource_id,
      case when
        (attributes:AccessLog:Enabled)::boolean is distinct from true
        then 'fail'
        else 'pass'
      end as status
    from
        aws_elbv1_load_balancers
)
{% endmacro %}

{% macro postgres__alb_logging_enabled(framework, check_id) %}
(select
  '{{framework}}' as framework,
  '{{check_id}}' as check_id,
  'Application and Classic Load Balancers logging should be enabled' as title,
  lb.account_id,
  lb.arn as resource_id,
  case when
    lb.type = 'application' and (a.value)::boolean is not true -- TODO check
    then 'fail'
    else 'pass'
  end as status
  from aws_elbv2_load_balancers lb
    inner join
        aws_elbv2_load_balancer_attributes a on
            a.load_balancer_arn = lb.arn AND a.key='access_logs.s3.enabled')
union
(
    select
      '{{framework}}' as framework,
      '{{check_id}}' as check_id,
      'Application and Classic Load Balancers logging should be enabled' as title,
      account_id,
      arn as resource_id,
      case when
        (attributes->'AccessLog'->>'Enabled')::boolean is not true
        then 'fail'
        else 'pass'
      end as status
    from
        aws_elbv1_load_balancers
)
{% endmacro %}

{% macro default__alb_logging_enabled(framework, check_id) %}{% endmacro %}

{% macro bigquery__alb_logging_enabled(framework, check_id) %}
(select
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'Application and Classic Load Balancers logging should be enabled' as title,
  lb.account_id,
  lb.arn as resource_id,
  case when
    lb.type = 'application' and CAST( a.value AS BOOL) is distinct from true -- TODO check
    then 'fail'
    else 'pass'
  end as status
  from {{ full_table_name("aws_elbv2_load_balancers") }} lb
    inner join
        {{ full_table_name("aws_elbv2_load_balancer_attributes") }} a on
            a.load_balancer_arn = lb.arn AND a.key='access_logs.s3.enabled')
union all
(
    select
      '{{framework}}' As framework,
      '{{check_id}}' As check_id,
      'Application and Classic Load Balancers logging should be enabled' as title,
      account_id,
      arn as resource_id,
      case when
        CAST( JSON_VALUE(attributes.AccessLog.Enabled) AS BOOL) is distinct from true
        then 'fail'
        else 'pass'
      end as status
    from
        {{ full_table_name("aws_elbv1_load_balancers") }} 
)
{% endmacro %}

{% macro athena__alb_logging_enabled(framework, check_id) %}

(select
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'Application and Classic Load Balancers logging should be enabled' as title,
  lb.account_id,
  lb.arn as resource_id,
  case when
    lb.type = 'application' and cast(a.value as boolean) is distinct from true -- TODO check
    then 'fail'
    else 'pass'
  end as status
  from aws_elbv2_load_balancers lb
    inner join
        aws_elbv2_load_balancer_attributes a on
            a.load_balancer_arn = lb.arn AND a.key='access_logs.s3.enabled')
union
(
    select
      '{{framework}}' As framework,
      '{{check_id}}' As check_id,
      'Application and Classic Load Balancers logging should be enabled' as title,
      account_id,
      arn as resource_id,
      case when
        cast(json_extract_scalar(attributes, '$.AccessLog.Enabled') as boolean) is distinct from true
        then 'fail'
        else 'pass'
      end as status
    from
        aws_elbv1_load_balancers
)
{% endmacro %}