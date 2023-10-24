{% macro redshift_cluster_kms_enabled(framework, check_id) %}
insert into aws_policy_results
select
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'Redshift clusters should be encrypted at rest' as title,
    account_id,
    arn as resource_id,
    CASE
    WHEN encrypted AND kms_key_id is not null THEN 'pass'
    ELSE 'fail'
    END AS status
from aws_redshift_clusters
{% endmacro %}