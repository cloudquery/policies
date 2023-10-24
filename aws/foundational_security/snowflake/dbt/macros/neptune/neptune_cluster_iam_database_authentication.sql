{% macro neptune_cluster_iam_database_authentication(framework, check_id) %}
insert into aws_policy_results
select
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'Neptune DB clusters should have IAM database authentication enabled' as title,
    account_id,
    arn as resource_id,
    case when
    iam_database_authentication_enabled = true then 'pass'
    else 'fail'
    end as status
from 
    aws_neptune_clusters
{% endmacro %}