{% macro rds_event_notifications_subscription_should_be_configured_for_critical_database_security_group_events(framework, check_id) %}
  {{ return(adapter.dispatch('rds_event_notifications_subscription_should_be_configured_for_critical_database_security_group_events')(framework, check_id)) }}
{% endmacro %}

{% macro default__rds_event_notifications_subscription_should_be_configured_for_critical_database_security_group_events(framework, check_id) %}{% endmacro %}

{% macro postgres__rds_event_notifications_subscription_should_be_configured_for_critical_database_security_group_events(framework, check_id) %}

with any_category as (
    select distinct TRUE as any_category
    from aws_rds_event_subscriptions
    where
        (source_type is null or source_type = 'db-security-group')
        and event_categories_list is null
),

any_source_id as (
    select COALESCE(ARRAY_AGG(category), '{}'::TEXT[]) as any_source_categories
    from
        aws_rds_event_subscriptions,
        UNNEST(event_categories_list) as category
    where
        source_type = 'db-security-group'
        and event_categories_list is not null
),

specific_categories as (
    select
        source_id,
        ARRAY_AGG(category) as specific_cats
    from
        aws_rds_event_subscriptions,
        UNNEST(source_ids_list) as source_id,
        UNNEST(event_categories_list) as category
    where source_type = 'db-security-group'
    group by source_id
)

select
    '{{framework}}' as framework,
    '{{check_id}}' as check_id,
    'An RDS event notifications subscription should be configured for critical database security group events' as title,
    aws_rds_db_security_groups.account_id,
    aws_rds_db_security_groups.arn as resource_id,
    case when
        any_category is not TRUE
        and not any_source_categories @> '{"configuration change","failure"}'
        and (
            specific_cats is null or not specific_cats @> '{"configuration change","failure"}'
        )
    then 'fail' else 'pass' end as status
from
    aws_rds_db_security_groups
left outer join any_category on TRUE
inner join any_source_id on TRUE
left outer join
    specific_categories on
        aws_rds_db_security_groups.db_security_group_name = specific_categories.source_id
{% endmacro %}
