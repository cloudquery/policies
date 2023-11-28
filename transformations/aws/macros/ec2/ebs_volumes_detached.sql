{% macro ebs_volumes_detached(framework, check_id) %}
  {{ return(adapter.dispatch('ebs_volumes_detached')(framework, check_id)) }}
{% endmacro %}

{% macro default__ebs_volumes_detached(framework, check_id) %}{% endmacro %}

{% macro postgres__ebs_volumes_detached(framework, check_id) %}
select
       '{{framework}}'          as framework,
       '{{check_id}}'           as check_id,
       'Detached EBS volume' as title,
       account_id,
       arn            as resource_id,
       'fail'                as status
from aws_ec2_ebs_volumes
where coalesce(jsonb_array_length(attachments), 0) = 0
{% endmacro %}
