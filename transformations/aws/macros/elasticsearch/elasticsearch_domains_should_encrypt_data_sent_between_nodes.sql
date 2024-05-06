{% macro elasticsearch_domains_should_encrypt_data_sent_between_nodes(framework, check_id) %}
  {{ return(adapter.dispatch('elasticsearch_domains_should_encrypt_data_sent_between_nodes')(framework, check_id)) }}
{% endmacro %}

{% macro snowflake__elasticsearch_domains_should_encrypt_data_sent_between_nodes(framework, check_id) %}
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

{% macro postgres__elasticsearch_domains_should_encrypt_data_sent_between_nodes(framework, check_id) %}
select
  '{{framework}}' as framework,
  '{{check_id}}' as check_id,
  'Elasticsearch domains should encrypt data sent between nodes' as title,
  account_id,
  arn as resource_id,
  case when
        (node_to_node_encryption_options->>'Enabled')::boolean is not true
    then 'fail'
    else 'pass'
  end as status
from aws_elasticsearch_domains
{% endmacro %}

{% macro default__elasticsearch_domains_should_encrypt_data_sent_between_nodes(framework, check_id) %}{% endmacro %}

{% macro bigquery__elasticsearch_domains_should_encrypt_data_sent_between_nodes(framework, check_id) %}
select
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'Elasticsearch domains should encrypt data sent between nodes' as title,
  account_id,
  arn as resource_id,
  case when
        CAST( JSON_VALUE(node_to_node_encryption_options.Enabled) AS BOOL) is distinct from true
    then 'fail'
    else 'pass'
  end as status
from {{ full_table_name("aws_elasticsearch_domains") }}
{% endmacro %}

{% macro athena__elasticsearch_domains_should_encrypt_data_sent_between_nodes(framework, check_id) %}
select
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'Elasticsearch domains should encrypt data sent between nodes' as title,
  account_id,
  arn as resource_id,
  case when
        cast(json_extract_scalar(node_to_node_encryption_options, '$.Enabled') as boolean) is distinct from true
    then 'fail'
    else 'pass'
  end as status
from aws_elasticsearch_domains
{% endmacro %}