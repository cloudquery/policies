{% macro elb_load_balancers_unused(framework, check_id) %}
  {{ return(adapter.dispatch('elb_load_balancers_unused')(framework, check_id)) }}
{% endmacro %}

{% macro default__elb_load_balancers_unused(framework, check_id) %}{% endmacro %}

{% macro postgres__elb_load_balancers_unused(framework, check_id) %}
with listener as (select distinct load_balancer_arn from aws_elbv2_listeners),
     target_group as (select distinct unnest(load_balancer_arns) as load_balancer_arn
                      from aws_elbv2_target_groups)
select
       '{{framework}}'               as framework,
       '{{check_id}}'                as check_id,
       'Unused ELB load balancer' as title,
       lb.account_id,
       lb.arn                     as resource_id,
       'fail'                     as status
from aws_elbv2_load_balancers lb
         left join listener on listener.load_balancer_arn = lb.arn
         left join target_group on target_group.load_balancer_arn = lb.arn
where listener.load_balancer_arn is null
   or target_group.load_balancer_arn is null{% endmacro %}
