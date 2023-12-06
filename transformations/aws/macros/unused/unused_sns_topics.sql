{% macro unused_sns_topics(framework, check_id) %}
  {{ return(adapter.dispatch('unused_sns_topics')(framework, check_id)) }}
{% endmacro %}

{% macro default__unused_sns_topics(framework, check_id) %}{% endmacro %}

{% macro postgres__unused_sns_topics(framework, check_id) %}
with subscription as (select distinct topic_arn from aws_sns_subscriptions),
unused_topics as (
select 
       topic.account_id,
       topic.arn          as resource_id
from aws_sns_topics topic
         left join subscription on subscription.topic_arn = topic.arn
where subscription.topic_arn is null)
SELECT 
    ut.account_id,
    ut.resource_id,
    rbc.cost
FROM unused_topics ut
JOIN {{ ref('aws_cost__by_resources') }} rbc ON ut.resource_id = rbc.line_item_resource_id
{% endmacro %}

{% macro snowflake__unused_sns_topics(framework, check_id) %}
{% endmacro %}