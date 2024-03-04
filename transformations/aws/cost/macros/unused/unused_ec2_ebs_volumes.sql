{% macro unused_ec2_ebs_volumes(framework, check_id) %}
  {{ return(adapter.dispatch('unused_ec2_ebs_volumes')(framework, check_id)) }}
{% endmacro %}

{% macro default__unused_ec2_ebs_volumes(framework, check_id) %}{% endmacro %}

{% macro postgres__unused_ec2_ebs_volumes(framework, check_id) %}
select 
       ev.account_id,
       ev.arn            as resource_id,
       rbc.cost,
       'ebs_volumes' as resource_type
from aws_ec2_ebs_volumes ev
JOIN {{ ref('aws_cost__by_resources') }} rbc ON ev.arn = rbc.line_item_resource_id 
where coalesce(jsonb_array_length(ev.attachments), 0) = 0
{% endmacro %}

{% macro snowflake__unused_ec2_ebs_volumes(framework, check_id) %}

{% endmacro %}