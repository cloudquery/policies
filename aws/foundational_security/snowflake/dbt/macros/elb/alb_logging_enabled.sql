{% macro alb_logging_enabled(framework, check_id) %}
insert into aws_policy_results
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