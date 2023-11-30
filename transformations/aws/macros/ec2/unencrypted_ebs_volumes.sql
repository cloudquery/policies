{% macro unencrypted_ebs_volumes(framework, check_id) %}
  {{ return(adapter.dispatch('unencrypted_ebs_volumes')(framework, check_id)) }}
{% endmacro %}

{% macro snowflake__unencrypted_ebs_volumes(framework, check_id) %}
select
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'Attached EBS volumes should be encrypted at rest' as title,
    account_id,
    arn as resource_id,
    case when
        encrypted = FALSE
        then 'fail'
        else 'pass'
    end as status
from aws_ec2_ebs_volumes
{% endmacro %}

{% macro postgres__unencrypted_ebs_volumes(framework, check_id) %}
select
    '{{framework}}' as framework,
    '{{check_id}}' as check_id,
    'Attached EBS volumes should be encrypted at rest' as title,
    account_id,
    arn as resource_id,
    case when
        encrypted is FALSE
        then 'fail'
        else 'pass'
    end as status
from aws_ec2_ebs_volumes
{% endmacro %}

{% macro default__unencrypted_ebs_volumes(framework, check_id) %}{% endmacro %}
                    