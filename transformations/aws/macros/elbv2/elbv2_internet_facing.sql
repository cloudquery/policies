{% macro elbv2_internet_facing(framework, check_id) %}
  {{ return(adapter.dispatch('elbv2_internet_facing')(framework, check_id)) }}
{% endmacro %}

{% macro default__elbv2_internet_facing(framework, check_id) %}{% endmacro %}

{% macro postgres__elbv2_internet_facing(framework, check_id) %}
select
    '{{framework}}' as framework,
    '{{check_id}}' as check_id,
    'Find all ELB V2s that are Internet Facing' AS title,
    account_id,
    arn as resource_id,
    case when scheme = 'internet-facing' then 'fail' else 'pass' end as status
from
    aws_elbv2_load_balancers
{% endmacro %}

{% macro bigquery__elbv2_internet_facing(framework, check_id) %}
select
    '{{framework}}' as framework,
    '{{check_id}}' as check_id,
    'Find all ELB V2s that are Internet Facing' AS title,
    account_id,
    arn as resource_id,
    case when scheme = 'internet-facing' then 'fail' else 'pass' end as status
from
    {{ full_table_name("aws_elbv2_load_balancers") }}
{% endmacro %}

{% macro snowflake__elbv2_internet_facing(framework, check_id) %}
select
    '{{framework}}' as framework,
    '{{check_id}}' as check_id,
    'Find all ELB V2s that are Internet Facing' AS title,
    account_id,
    arn as resource_id,
    case when scheme = 'internet-facing' then 'fail' else 'pass' end as status
from
    aws_elbv2_load_balancers
{% endmacro %}

{% macro athena__elbv2_internet_facing(framework, check_id) %}
select
    '{{framework}}' as framework,
    '{{check_id}}' as check_id,
    'Find all ELB V2s that are Internet Facing' AS title,
    account_id,
    arn as resource_id,
    case when scheme = 'internet-facing' then 'fail' else 'pass' end as status
from
    aws_elbv2_load_balancers
{% endmacro %}