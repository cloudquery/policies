{% macro instances_with_public_ip(framework, check_id) %}
select
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'EC2 instances should not have a public IP address' as title,
    account_id,
    instance_id as resource_id,
    case when
        public_ip_address is not null
        then 'fail'
        else 'pass'
    end as status
from aws_ec2_instances
{% endmacro %}