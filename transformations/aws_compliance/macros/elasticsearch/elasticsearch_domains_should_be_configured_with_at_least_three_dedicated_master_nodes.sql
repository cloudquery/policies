{% macro elasticsearch_domains_should_be_configured_with_at_least_three_dedicated_master_nodes(framework, check_id) %}
  {{ return(adapter.dispatch('elasticsearch_domains_should_be_configured_with_at_least_three_dedicated_master_nodes')(framework, check_id)) }}
{% endmacro %}

{% macro snowflake__elasticsearch_domains_should_be_configured_with_at_least_three_dedicated_master_nodes(framework, check_id) %}
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

{% macro postgres__elasticsearch_domains_should_be_configured_with_at_least_three_dedicated_master_nodes(framework, check_id) %}
select
  '{{framework}}' as framework,
  '{{check_id}}' as check_id,
  'Elasticsearch domains should be configured with at least three dedicated master nodes' as title,
  account_id,
  arn as resource_id,
  case when
    (elasticsearch_cluster_config->>'DedicatedMasterEnabled')::boolean is not TRUE
    or (elasticsearch_cluster_config->>'DedicatedMasterCount')::integer is null
    or (elasticsearch_cluster_config->>'DedicatedMasterCount')::integer < 3
    then 'fail'
    else 'pass'
  end as status
from aws_elasticsearch_domains
{% endmacro %}
