{% macro unencrypted_ebs_volumes(framework, check_id) %}
insert into aws_policy_results
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
from aws_ec2_ebs_volumes;
{% endmacro %}