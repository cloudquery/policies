{% macro neptune_cluster_snapshot_public_prohibited(framework, check_id) %}
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