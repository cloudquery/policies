{% macro elasticsearch_domains_should_encrypt_data_sent_between_nodes(framework, check_id) %}
insert into aws_policy_results
select
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'Elasticsearch domains should encrypt data sent between nodes' as title,
  account_id,
  arn as resource_id,
  case when
        (node_to_node_encryption_options:Enabled)::boolean is distinct from true
    then 'fail'
    else 'pass'
  end as status
from aws_elasticsearch_domains
{% endmacro %}