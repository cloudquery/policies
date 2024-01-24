{% macro connections_to_elasticsearch_domains_should_be_encrypted_using_tls_1_2(framework, check_id) %}
  {{ return(adapter.dispatch('connections_to_elasticsearch_domains_should_be_encrypted_using_tls_1_2')(framework, check_id)) }}
{% endmacro %}

{% macro snowflake__connections_to_elasticsearch_domains_should_be_encrypted_using_tls_1_2(framework, check_id) %}
select
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'Connections to Elasticsearch domains should be encrypted using TLS 1.2' as title,
  account_id,
  arn as resource_id,
  case when
    domain_endpoint_options:TLSSecurityPolicy is distinct from 'Policy-Min-TLS-1-2-2019-07'
    then 'fail'
    else 'pass'
  end as status
from aws_elasticsearch_domains
{% endmacro %}

{% macro postgres__connections_to_elasticsearch_domains_should_be_encrypted_using_tls_1_2(framework, check_id) %}
select
  '{{framework}}' as framework,
  '{{check_id}}' as check_id,
  'Connections to Elasticsearch domains should be encrypted using TLS 1.2' as title,
  account_id,
  arn as resource_id,
  case when
    domain_endpoint_options->>'TLSSecurityPolicy' is distinct from 'Policy-Min-TLS-1-2-2019-07'
    then 'fail'
    else 'pass'
  end as status
from aws_elasticsearch_domains
{% endmacro %}

{% macro default__connections_to_elasticsearch_domains_should_be_encrypted_using_tls_1_2(framework, check_id) %}{% endmacro %}

{% macro bigquery__connections_to_elasticsearch_domains_should_be_encrypted_using_tls_1_2(framework, check_id) %}
select
  '{{framework}}' as framework,
  '{{check_id}}' as check_id,
  'Connections to Elasticsearch domains should be encrypted using TLS 1.2' as title,
  account_id,
  arn as resource_id,
  case when
    JSON_VALUE(domain_endpoint_options.TLSSecurityPolicy) is distinct from 'Policy-Min-TLS-1-2-2019-07'
    then 'fail'
    else 'pass'
  end as status
from {{ full_table_name("aws_elasticsearch_domains") }}
{% endmacro %}