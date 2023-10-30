{% macro images_unused(framework, check_id) %}
  {{ return(adapter.dispatch('images_unused')(framework, check_id)) }}
{% endmacro %}

{% macro default__images_unused(framework, check_id) %}{% endmacro %}

{% macro postgres__images_unused(framework, check_id) %}
select
       '{{framework}}'           as framework,
       '{{check_id}}'            as check_id,
       'Unused own EC2 image' as title,
       account_id,
       arn                    as resource_id,
       'fail'                 as status
from aws_ec2_images
where coalesce(jsonb_array_length(block_device_mappings), 0) = 0
{% endmacro %}
