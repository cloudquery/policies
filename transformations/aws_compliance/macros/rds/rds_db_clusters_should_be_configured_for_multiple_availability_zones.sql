{% macro rds_db_clusters_should_be_configured_for_multiple_availability_zones(framework, check_id) %}
  {{ return(adapter.dispatch('rds_db_clusters_should_be_configured_for_multiple_availability_zones')(framework, check_id)) }}
{% endmacro %}

{% macro default__rds_db_clusters_should_be_configured_for_multiple_availability_zones(framework, check_id) %}{% endmacro %}

{% macro postgres__rds_db_clusters_should_be_configured_for_multiple_availability_zones(framework, check_id) %}
select
    '{{framework}}' as framework,
    '{{check_id}}' as check_id,
    'RDS DB clusters should be configured for multiple Availability Zones' as title,
    account_id,
    arn AS resource_id,
    case when multi_az is not TRUE then 'fail' else 'pass' end as status
from aws_rds_clusters
{% endmacro %}
