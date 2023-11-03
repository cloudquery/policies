{% macro clusters_should_use_enhanced_vpc_routing(framework, check_id) %}
  {{ return(adapter.dispatch('clusters_should_use_enhanced_vpc_routing')(framework, check_id)) }}
{% endmacro %}

{% macro snowflake__clusters_should_use_enhanced_vpc_routing(framework, check_id) %}
select
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'Amazon Redshift clusters should use enhanced VPC routing' as title,
    account_id,
    arn as resource_id,
    case when
        enhanced_vpc_routing is distinct from TRUE
    then 'fail' else 'pass' end as status
from aws_redshift_clusters
{% endmacro %}

{% macro postgres__clusters_should_use_enhanced_vpc_routing(framework, check_id) %}
select
    '{{framework}}' as framework,
    '{{check_id}}' as check_id,
    'Amazon Redshift clusters should use enhanced VPC routing' as title,
    account_id,
    arn as resource_id,
    case when
        enhanced_vpc_routing is FALSE or enhanced_vpc_routing is null
    then 'fail' else 'pass' end as status
from aws_redshift_clusters
{% endmacro %}
