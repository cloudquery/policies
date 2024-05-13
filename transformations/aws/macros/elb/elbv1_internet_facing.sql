{% macro elbv1_internet_facing(framework, check_id) %}
  {{ return(adapter.dispatch('elbv1_internet_facing')(framework, check_id)) }}
{% endmacro %}

{% macro default__elbv1_internet_facing(framework, check_id) %}{% endmacro %}

{% macro postgres__elbv1_internet_facing(framework, check_id) %}
select
    '{{framework}}' as framework,
    '{{check_id}}' as check_id,
    'Find all Classic ELBs that are Internet Facing' AS title,
    account_id,
    arn as resource_id,
    case when scheme = 'internet-facing' then 'fail' else 'pass' end as status
from
    aws_elbv1_load_balancers
{% endmacro %}

{% macro bigquery__elbv1_internet_facing(framework, check_id) %}
select
    '{{framework}}' as framework,
    '{{check_id}}' as check_id,
    'Find all Classic ELBs that are Internet Facing' AS title,
    account_id,
    arn as resource_id,
    case when scheme = 'internet-facing' then 'fail' else 'pass' end as status
from
    {{ full_table_name("aws_elbv1_load_balancers") }}
{% endmacro %}

{% macro snowflake__elbv1_internet_facing(framework, check_id) %}
select
    '{{framework}}' as framework,
    '{{check_id}}' as check_id,
    'Find all Classic ELBs that are Internet Facing' AS title,
    account_id,
    arn as resource_id,
    case when scheme = 'internet-facing' then 'fail' else 'pass' end as status
from
    aws_elbv1_load_balancers
{% endmacro %}

{% macro athena__elbv1_internet_facing(framework, check_id) %}
select
    '{{framework}}' as framework,
    '{{check_id}}' as check_id,
    'Find all Classic ELBs that are Internet Facing' AS title,
    account_id,
    arn as resource_id,
    case when scheme = 'internet-facing' then 'fail' else 'pass' end as status
from
    aws_elbv1_load_balancers
{% endmacro %}