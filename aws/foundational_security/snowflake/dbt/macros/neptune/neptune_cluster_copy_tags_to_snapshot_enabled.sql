{% macro neptune_cluster_copy_tags_to_snapshot_enabled(framework, check_id) %}
insert into aws_policy_results
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