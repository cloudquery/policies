{% macro rds_automatic_minor_version_upgrades_should_be_enabled(framework, check_id) %}
  {{ return(adapter.dispatch('rds_automatic_minor_version_upgrades_should_be_enabled')(framework, check_id)) }}
{% endmacro %}

{% macro snowflake__rds_automatic_minor_version_upgrades_should_be_enabled(framework, check_id) %}
select
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'RDS automatic minor version upgrades should be enabled' as title,
    account_id,
    arn AS resource_id,
    case when auto_minor_version_upgrade != TRUE then 'fail' else 'pass' end as status
from aws_rds_instances
{% endmacro %}

{% macro postgres__rds_automatic_minor_version_upgrades_should_be_enabled(framework, check_id) %}
select
    '{{framework}}' as framework,
    '{{check_id}}' as check_id,
    'RDS automatic minor version upgrades should be enabled' as title,
    account_id,
    arn AS resource_id,
    case when auto_minor_version_upgrade is not TRUE then 'fail' else 'pass' end as status
from aws_rds_instances
{% endmacro %}
