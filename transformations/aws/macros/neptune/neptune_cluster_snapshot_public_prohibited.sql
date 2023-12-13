{% macro neptune_cluster_snapshot_public_prohibited(framework, check_id) %}
  {{ return(adapter.dispatch('neptune_cluster_snapshot_public_prohibited')(framework, check_id)) }}
{% endmacro %}

{% macro default__neptune_cluster_snapshot_public_prohibited(framework, check_id) %}{% endmacro %}

{% macro postgres__neptune_cluster_snapshot_public_prohibited(framework, check_id) %}
select
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'Neptune DB cluster snapshots should not be public' as title,
    account_id,
    arn as resource_id,
    case when
    attributes[0] ->> 'AttributeName' = 'restore' 
	and attributes[0] -> 'AttributeValues' ? 'all'
	then 'fail'
    else 'pass'
    end as status
from 
    aws_neptune_cluster_snapshots
{% endmacro %}

{% macro snowflake__neptune_cluster_snapshot_public_prohibited(framework, check_id) %}
select
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'Neptune DB cluster snapshots should not be public' as title,
    account_id,
    arn as resource_id,
    case when
    attributes[0]:AttributeName = 'restore' and ARRAY_CONTAINS('all'::variant, attributes[0]:AttributeValues) then 'fail'
    else 'pass'
    end as status
from 
    aws_neptune_cluster_snapshots
{% endmacro %}