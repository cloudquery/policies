{% macro elasticsearch_domains_should_have_at_least_three_data_nodes(framework, check_id) %}
insert into aws_policy_results
select
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'Elasticsearch domains should have at least three data nodes' as title,
  account_id,
  arn as resource_id,
  case when
    not (elasticsearch_cluster_config:ZoneAwarenessEnabled)::boolean
    or (elasticsearch_cluster_config:InstanceCount)::integer is null
    or (elasticsearch_cluster_config:InstanceCount)::integer < 3
    then 'fail'
    else 'pass'
  end as status
from aws_elasticsearch_domains
{% endmacro %}