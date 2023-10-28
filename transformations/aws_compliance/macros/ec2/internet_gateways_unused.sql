{% macro internet_gateways_unused(framework, check_id) %}
  {{ return(adapter.dispatch('internet_gateways_unused')(framework, check_id)) }}
{% endmacro %}

{% macro default__internet_gateways_unused(framework, check_id) %}{% endmacro %}

{% macro postgres__internet_gateways_unused(framework, check_id) %}
select
       '{{framework}}'              as framework,
       '{{check_id}}'               as check_id,
       'Unused internet gateway' as title,
       account_id,
       arn                       as resource_id,
       'fail'                    as status
from aws_ec2_internet_gateways
where coalesce(jsonb_array_length(attachments), 0) = 0;
{% endmacro %}
