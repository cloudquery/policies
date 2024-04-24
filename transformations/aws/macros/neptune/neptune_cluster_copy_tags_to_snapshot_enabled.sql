{% macro neptune_cluster_copy_tags_to_snapshot_enabled(framework, check_id) %}
  {{ return(adapter.dispatch('neptune_cluster_copy_tags_to_snapshot_enabled')(framework, check_id)) }}
{% endmacro %}

{% macro default__neptune_cluster_copy_tags_to_snapshot_enabled(framework, check_id) %}{% endmacro %}

{% macro postgres__neptune_cluster_copy_tags_to_snapshot_enabled(framework, check_id) %}
select
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'Neptune DB clusters should be configured to copy tags to snapshots' as title,
    account_id,
    arn as resource_id,
    case when
     copy_tags_to_snapshot = true then 'pass'
     else 'fail'
     end as status
from 
    aws_neptune_clusters
{% endmacro %}

{% macro snowflake__neptune_cluster_copy_tags_to_snapshot_enabled(framework, check_id) %}
select
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'Neptune DB clusters should be configured to copy tags to snapshots' as title,
    account_id,
    arn as resource_id,
    case when
     copy_tags_to_snapshot = true then 'pass'
     else 'fail'
     end as status
from 
    aws_neptune_clusters
{% endmacro %}

{% macro bigquery__neptune_cluster_copy_tags_to_snapshot_enabled(framework, check_id) %}
select
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'Neptune DB clusters should be configured to copy tags to snapshots' as title,
    account_id,
    arn as resource_id,
    case when
     copy_tags_to_snapshot = true then 'pass'
     else 'fail'
     end as status
from 
    {{ full_table_name("aws_neptune_clusters") }}
{% endmacro %}

{% macro athena__neptune_cluster_copy_tags_to_snapshot_enabled(framework, check_id) %}
select
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'Neptune DB clusters should be configured to copy tags to snapshots' as title,
    account_id,
    arn as resource_id,
    case when
     copy_tags_to_snapshot = true then 'pass'
     else 'fail'
     end as status
from 
    aws_neptune_clusters
{% endmacro %}