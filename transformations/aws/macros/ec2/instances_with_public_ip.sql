{% macro instances_with_public_ip(framework, check_id) %}
  {{ return(adapter.dispatch('instances_with_public_ip')(framework, check_id)) }}
{% endmacro %}

{% macro snowflake__instances_with_public_ip(framework, check_id) %}
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

{% macro postgres__instances_with_public_ip(framework, check_id) %}
select
    '{{framework}}' as framework,
    '{{check_id}}' as check_id,
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

{% macro default__instances_with_public_ip(framework, check_id) %}{% endmacro %}

{% macro bigquery__instances_with_public_ip(framework, check_id) %}
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
from {{ full_table_name("aws_ec2_instances") }}
{% endmacro %}

{% macro athena__instances_with_public_ip(framework, check_id) %}
SELECT
    '{{framework}}' AS framework,
    '{{check_id}}' AS check_id,
    'EC2 instances should not have a public IP address' AS title,
    account_id,
    instance_id AS resource_id,
    CASE 
        WHEN public_ip_address IS NOT NULL THEN 'fail'
        ELSE 'pass'
    END AS status
FROM
    aws_ec2_instances
{% endmacro %}