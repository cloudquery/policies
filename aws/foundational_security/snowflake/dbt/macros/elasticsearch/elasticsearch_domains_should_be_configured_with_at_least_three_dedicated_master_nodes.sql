{% macro elasticsearch_domains_should_be_configured_with_at_least_three_dedicated_master_nodes(framework, check_id) %}
insert into aws_policy_results
select
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'Elasticsearch domains should be configured with at least three dedicated master nodes' as title,
  account_id,
  arn as resource_id,
  case when
    (elasticsearch_cluster_config:DedicatedMasterEnabled)::boolean is distinct from true
    or (elasticsearch_cluster_config:DedicatedMasterCount)::integer is null
    or (elasticsearch_cluster_config:DedicatedMasterCount)::integer < 3
    then 'fail'
    else 'pass'
  end as status
from aws_elasticsearch_domains
{% endmacro %}