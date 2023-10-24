{% macro subnets_that_assign_public_ips(framework, check_id) %}
insert into aws_policy_results
select
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'EC2 subnets should not automatically assign public IP addresses' as title,
    owner_id as account_id,
    arn as resource_id,
    case when
        map_public_ip_on_launch = TRUE
        then 'fail'
        else 'pass'
    end
from aws_ec2_subnets
{% endmacro %}