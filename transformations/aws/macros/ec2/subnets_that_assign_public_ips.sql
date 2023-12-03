{% macro subnets_that_assign_public_ips(framework, check_id) %}
  {{ return(adapter.dispatch('subnets_that_assign_public_ips')(framework, check_id)) }}
{% endmacro %}

{% macro snowflake__subnets_that_assign_public_ips(framework, check_id) %}
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

{% macro postgres__subnets_that_assign_public_ips(framework, check_id) %}
select
    '{{framework}}' as framework,
    '{{check_id}}' as check_id,
    'EC2 subnets should not automatically assign public IP addresses' as title,
    owner_id as account_id,
    arn as resource_id,
    case when
        map_public_ip_on_launch is true
        then 'fail'
        else 'pass'
    end
from aws_ec2_subnets
{% endmacro %}

{% macro default__subnets_that_assign_public_ips(framework, check_id) %}{% endmacro %}
                    