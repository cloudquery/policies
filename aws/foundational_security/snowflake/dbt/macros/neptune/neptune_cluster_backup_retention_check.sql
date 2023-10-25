{% macro neptune_cluster_backup_retention_check(framework, check_id) %}
select
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'Neptune DB clusters should have automated backups enabled' as title,
    account_id,
    arn as resource_id,
    case when
    backup_retention_period IS NULL
    OR backup_retention_period < 7
    then 'fail'
    else 'pass'
    end as status
from 
    aws_neptune_clusters
{% endmacro %}