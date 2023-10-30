{% macro rds_clusters_should_have_deletion_protection_enabled(framework, check_id) %}
  {{ return(adapter.dispatch('rds_clusters_should_have_deletion_protection_enabled')(framework, check_id)) }}
{% endmacro %}

{% macro default__rds_clusters_should_have_deletion_protection_enabled(framework, check_id) %}{% endmacro %}

{% macro postgres__rds_clusters_should_have_deletion_protection_enabled(framework, check_id) %}
select
    '{{framework}}' as framework,
    '{{check_id}}' as check_id,
    'RDS clusters should have deletion protection enabled' as title,
    account_id,
    arn AS resource_id,
    case when deletion_protection is not TRUE then 'fail' else 'pass' end as status
from aws_rds_clusters
{% endmacro %}
