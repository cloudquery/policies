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

{% macro default__elasticsearch_domains_should_be_configured_with_at_least_three_dedicated_master_nodes(framework, check_id) %}{% endmacro %}

{% macro bigquery__elasticsearch_domains_should_be_configured_with_at_least_three_dedicated_master_nodes(framework, check_id) %}
select
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'Elasticsearch domains should be configured with at least three dedicated master nodes' as title,
  account_id,
  arn as resource_id,
  case when
    CAST( JSON_VALUE(elasticsearch_cluster_config.DedicatedMasterEnabled) AS BOOL) is distinct from true
    or CAST(JSON_VALUE(elasticsearch_cluster_config.DedicatedMasterCount) AS INT64) is null
    or CAST(JSON_VALUE(elasticsearch_cluster_config.DedicatedMasterCount) AS INT64) < 3
    then 'fail'
    else 'pass'
  end as status
from {{ full_table_name("aws_elasticsearch_domains") }}
{% endmacro %}

{% macro athena__elasticsearch_domains_should_be_configured_with_at_least_three_dedicated_master_nodes(framework, check_id) %}
select
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'Elasticsearch domains should be configured with at least three dedicated master nodes' as title,
  account_id,
  arn as resource_id,
  case when
    cast(json_extract_scalar(elasticsearch_cluster_config, '$.DedicatedMasterEnabled') as boolean) is distinct from true
    or cast(json_extract_scalar(elasticsearch_cluster_config, '$.DedicatedMasterCount') as integer) is null
    or cast(json_extract_scalar(elasticsearch_cluster_config, '$.DedicatedMasterCount') as integer) < 3
    then 'fail'
    else 'pass'
  end as status
from aws_elasticsearch_domains
{% endmacro %}