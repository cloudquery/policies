{% macro autoscaling_groups_elb_check(framework, check_id) %}
  {{ return(adapter.dispatch('autoscaling_groups_elb_check')(framework, check_id)) }}
{% endmacro %}

{% macro default__autoscaling_groups_elb_check(framework, check_id) %}{% endmacro %}

{% macro postgres__autoscaling_groups_elb_check(framework, check_id) %}
select
    '{{framework}}' as framework,
    '{{check_id}}' as check_id,
    'Auto Scaling groups associated with a load balancer should use health checks' as title,
    account_id,
    arn as resource_id,
    case
        when ARRAY_LENGTH(load_balancer_names, 1) > 0 and health_check_type is distinct from 'ELB' then 'fail'
        else 'pass'
    end as status
from aws_autoscaling_groups
{% endmacro %}

{% macro snowflake__autoscaling_groups_elb_check(framework, check_id) %}
select
    '{{framework}}' as framework,
    '{{check_id}}' as check_id,
    'Auto Scaling groups associated with a load balancer should use health checks' as title,
    account_id,
    arn as resource_id,
    case
        when ARRAY_SIZE(load_balancer_names) > 0 and health_check_type is distinct from 'ELB' then 'fail'
        else 'pass'
    end as status
from aws_autoscaling_groups
{% endmacro %}

{% macro bigquery__autoscaling_groups_elb_check(framework, check_id) %}
select
    '{{framework}}' as framework,
    '{{check_id}}' as check_id,
    'Auto Scaling groups associated with a load balancer should use health checks' as title,
    account_id,
    arn as resource_id,
    case
        when ARRAY_LENGTH(load_balancer_names) > 0 and health_check_type is distinct from 'ELB' then 'fail'
        else 'pass'
    end as status
from {{ full_table_name("aws_autoscaling_groups") }}
{% endmacro %}

{% macro athena__autoscaling_groups_elb_check(framework, check_id) %}
select
    '{{framework}}' as framework,
    '{{check_id}}' as check_id,
    'Auto Scaling groups associated with a load balancer should use health checks' as title,
    account_id,
    arn as resource_id,
    case
        when cardinality(load_balancer_names) > 0 and health_check_type is distinct from 'ELB' then 'fail'
        else 'pass'
    end as status
from aws_autoscaling_groups
{% endmacro %}