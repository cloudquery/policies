{% macro get_unused_public_ips(framework, check_id) %}
  {{ return(adapter.dispatch('get_unused_public_ips')(framework, check_id)) }}
{% endmacro %}

{% macro default__get_unused_public_ips(framework, check_id) %}{% endmacro %}

{% macro postgres__get_unused_public_ips(framework, check_id) %}
select
    '{{framework}}' as framework,
    '{{check_id}}' as check_id,
    'Unused EC2 EIPs should be removed' as title,
    account_id,
    public_ip as resource_id,
    case when
        instance_id is null
        then 'fail'
        else 'pass'
    end as status
from aws_ec2_eips
{% endmacro %}

{% macro bigquery__get_unused_public_ips(framework, check_id) %}
select
    '{{framework}}' as framework,
    '{{check_id}}' as check_id,
    'Unused EC2 EIPs should be removed' as title,
    account_id,
    public_ip as resource_id,
    case when
        instance_id is null
        then 'fail'
        else 'pass'
    end as status
from {{ full_table_name("aws_ec2_eips") }}
{% endmacro %}

{% macro snowflake__get_unused_public_ips(framework, check_id) %}
select
    '{{framework}}' as framework,
    '{{check_id}}' as check_id,
    'Unused EC2 EIPs should be removed' as title,
    account_id,
    public_ip as resource_id,
    case when
        instance_id is null
        then 'fail'
        else 'pass'
    end as status
from aws_ec2_eips
{% endmacro %}

{% macro athena__get_unused_public_ips(framework, check_id) %}
select
    '{{framework}}' as framework,
    '{{check_id}}' as check_id,
    'Unused EC2 EIPs should be removed' as title,
    account_id,
    public_ip as resource_id,
    case when
        instance_id is null
        then 'fail'
        else 'pass'
    end as status
from aws_ec2_eips
{% endmacro %}