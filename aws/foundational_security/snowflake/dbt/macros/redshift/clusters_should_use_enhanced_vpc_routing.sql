{% macro clusters_should_use_enhanced_vpc_routing(framework, check_id) %}
insert into aws_policy_results
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