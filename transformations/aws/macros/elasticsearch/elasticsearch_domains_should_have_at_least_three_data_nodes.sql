{% macro elasticsearch_domains_should_have_at_least_three_data_nodes(framework, check_id) %}
  {{ return(adapter.dispatch('elasticsearch_domains_should_have_at_least_three_data_nodes')(framework, check_id)) }}
{% endmacro %}

{% macro snowflake__elasticsearch_domains_should_have_at_least_three_data_nodes(framework, check_id) %}
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

{% macro postgres__elasticsearch_domains_should_have_at_least_three_data_nodes(framework, check_id) %}
select
  '{{framework}}' as framework,
  '{{check_id}}' as check_id,
  'Elasticsearch domains should have at least three data nodes' as title,
  account_id,
  arn as resource_id,
  case when
    not (elasticsearch_cluster_config->>'ZoneAwarenessEnabled')::boolean
    or (elasticsearch_cluster_config->>'InstanceCount')::integer is null
    or (elasticsearch_cluster_config->>'InstanceCount')::integer < 3
    then 'fail'
    else 'pass'
  end as status
from aws_elasticsearch_domains
{% endmacro %}

{% macro default__elasticsearch_domains_should_have_at_least_three_data_nodes(framework, check_id) %}{% endmacro %}

{% macro bigquery__elasticsearch_domains_should_have_at_least_three_data_nodes(framework, check_id) %}
select
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'Elasticsearch domains should have at least three data nodes' as title,
  account_id,
  arn as resource_id,
  case when
    not CAST( JSON_VALUE(elasticsearch_cluster_config.ZoneAwarenessEnabled) AS BOOL)
    or CAST(JSON_VALUE(elasticsearch_cluster_config.InstanceCount) AS INT64) is null
    or CAST(JSON_VALUE(elasticsearch_cluster_config.InstanceCount) AS INT64) < 3
    then 'fail'
    else 'pass'
  end as status
from {{ full_table_name("aws_elasticsearch_domains") }}
{% endmacro %}  

{% macro athena__elasticsearch_domains_should_have_at_least_three_data_nodes(framework, check_id) %}
select
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'Elasticsearch domains should have at least three data nodes' as title,
  account_id,
  arn as resource_id,
  case when
    not cast(json_extract_scalar(elasticsearch_cluster_config, '$.ZoneAwarenessEnabled') as boolean)
    or cast(json_extract_scalar(elasticsearch_cluster_config, '$.InstanceCount') as integer) is null
    or cast(json_extract_scalar(elasticsearch_cluster_config, '$.InstanceCount') as integer) < 3
    then 'fail'
    else 'pass'
  end as status
from aws_elasticsearch_domains
{% endmacro %}