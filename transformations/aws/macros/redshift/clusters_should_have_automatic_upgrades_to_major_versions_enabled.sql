{% macro clusters_should_have_automatic_upgrades_to_major_versions_enabled(framework, check_id) %}
  {{ return(adapter.dispatch('clusters_should_have_automatic_upgrades_to_major_versions_enabled')(framework, check_id)) }}
{% endmacro %}

{% macro snowflake__clusters_should_have_automatic_upgrades_to_major_versions_enabled(framework, check_id) %}
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

{% macro postgres__clusters_should_have_automatic_upgrades_to_major_versions_enabled(framework, check_id) %}
select
    '{{framework}}' as framework,
    '{{check_id}}' as check_id,
    'Amazon Redshift should have automatic upgrades to major versions enabled' as title,
    account_id,
    arn as resource_id,
    case when
        allow_version_upgrade is FALSE or allow_version_upgrade is null
    then 'fail' else 'pass' end as status
from aws_redshift_clusters
{% endmacro %}

{% macro default__clusters_should_have_automatic_upgrades_to_major_versions_enabled(framework, check_id) %}{% endmacro %}
                    