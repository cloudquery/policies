{% macro unused_ec2_eips(framework, check_id) %}
  {{ return(adapter.dispatch('unused_ec2_eips')(framework, check_id)) }}
{% endmacro %}

{% macro default__unused_ec2_eips(framework, check_id) %}{% endmacro %}

{% macro postgres__unused_ec2_eips(framework, check_id) %}
select 
       eips.account_id,
       eips.allocation_id     as resource_id,
       rbc.cost,
       'ec2_eips' as resource_type
from aws_ec2_eips eips
JOIN {{ ref('aws_cost__by_resources') }} rbc ON eips.allocation_id = rbc.line_item_resource_id 
where eips.association_id is null
{% endmacro %}

{% macro snowflake__unused_ec2_eips(framework, check_id) %}

{% endmacro %}