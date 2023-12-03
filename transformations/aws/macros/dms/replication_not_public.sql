{% macro replication_not_public(framework, check_id) %}
  {{ return(adapter.dispatch('replication_not_public')(framework, check_id)) }}
{% endmacro %}

{% macro snowflake__replication_not_public(framework, check_id) %}
select
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'AWS Database Migration Service replication instances should not be public' as title,
    account_id,
    arn as resource_id,
    case when
        publicly_accessible = true
        then 'fail'
        else 'pass'
    end as status
from aws_dms_replication_instances
{% endmacro %}

{% macro postgres__replication_not_public(framework, check_id) %}
select
    '{{framework}}' as framework,
    '{{check_id}}' as check_id,
    'AWS Database Migration Service replication instances should not be public' as title,
    account_id,
    arn as resource_id,
    case when
        publicly_accessible is true
        then 'fail'
        else 'pass'
    end as status
from aws_dms_replication_instances
{% endmacro %}

{% macro default__replication_not_public(framework, check_id) %}{% endmacro %}
                    
{% macro bigquery__replication_not_public(framework, check_id) %}
select
    '{{framework}}' as framework,
    '{{check_id}}' as check_id,
    'AWS Database Migration Service replication instances should not be public' as title,
    account_id,
    arn as resource_id,
    case when
        publicly_accessible is true
        then 'fail'
        else 'pass'
    end as status
from {{ full_table_name("aws_dms_replication_instances") }}
{% endmacro %}