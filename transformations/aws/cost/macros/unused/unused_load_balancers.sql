{% macro unused_load_balancers(framework, check_id) %}
  {{ return(adapter.dispatch('unused_load_balancers')(framework, check_id)) }}
{% endmacro %}

{% macro default__unused_load_balancers(framework, check_id) %}{% endmacro %}

{% macro postgres__unused_load_balancers(framework, check_id) %}
SELECT 
    lb.account_id,
    lb.resource_id,
    rbc.cost,
       'load_balancers' as resource_type
FROM (
select 
       lb.account_id,
       lb.arn                     as resource_id
       from aws_elbv2_load_balancers lb
         left join (select distinct l.load_balancer_arn from aws_elbv2_listeners l) listener on listener.load_balancer_arn = lb.arn
         left join (select distinct unnest(tg.load_balancer_arns) as load_balancer_arn
                      from aws_elbv2_target_groups tg) target_group on target_group.load_balancer_arn = lb.arn
where listener.load_balancer_arn is null
   or target_group.load_balancer_arn is null) lb
JOIN {{ ref('aws_cost__by_resources') }} rbc ON lb.resource_id = rbc.line_item_resource_id
{% endmacro %}

{% macro snowflake__unused_load_balancers(framework, check_id) %}

{% endmacro %}