{% macro clusters_should_have_automatic_upgrades_to_major_versions_enabled(framework, check_id) %}
insert into aws_policy_results
select
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'Amazon Redshift should have automatic upgrades to major versions enabled' as title,
    account_id,
    arn as resource_id,
    case when
        allow_version_upgrade is distinct from TRUE
    then 'fail' else 'pass' end as status
from aws_redshift_clusters
{% endmacro %}