{% macro clusters_should_have_automatic_snapshots_enabled(framework, check_id) %}
  {{ return(adapter.dispatch('clusters_should_have_automatic_snapshots_enabled')(framework, check_id)) }}
{% endmacro %}

{% macro snowflake__clusters_should_have_automatic_snapshots_enabled(framework, check_id) %}
select
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'Amazon Redshift clusters should have automatic snapshots enabled' as title,
    account_id,
    arn as resource_id,
    case when
        automated_snapshot_retention_period < 7 or automated_snapshot_retention_period is null
    then 'fail' else 'pass' end as status
from aws_redshift_clusters
{% endmacro %}

{% macro postgres__clusters_should_have_automatic_snapshots_enabled(framework, check_id) %}
select
    '{{framework}}' as framework,
    '{{check_id}}' as check_id,
    'Amazon Redshift clusters should have automatic snapshots enabled' as title,
    account_id,
    arn as resource_id,
    case when
        automated_snapshot_retention_period < 7 or automated_snapshot_retention_period is null
    then 'fail' else 'pass' end as status
from aws_redshift_clusters
{% endmacro %}
