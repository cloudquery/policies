{% macro public_ips(framework, check_id) %}
  {{ return(adapter.dispatch('public_ips')(framework, check_id)) }}
{% endmacro %}

{% macro default__public_ips(framework, check_id) %}{% endmacro %}

{% macro postgres__public_ips(framework, check_id) %}
select
    '{{framework}}' as framework,
    '{{check_id}}' as check_id,
    'Find all instances with a public IP address' AS title,
    account_id,
    arn as resource_id,
    case when public_ip_address is not null then 'fail' else 'pass' end as status
from
    aws_ec2_instances
{% endmacro %}

{% macro bigquery__public_ips(framework, check_id) %}
select
    '{{framework}}' as framework,
    '{{check_id}}' as check_id,
    'Find all instances with a public IP address' AS title,
    account_id,
    arn as resource_id,
    case when public_ip_address is not null then 'fail' else 'pass' end as status
from
    {{ full_table_name("aws_ec2_instances") }}
{% endmacro %}
