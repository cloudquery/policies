{% macro elasticsearch_domains_should_have_encryption_at_rest_enabled(framework, check_id) %}
  {{ return(adapter.dispatch('elasticsearch_domains_should_have_encryption_at_rest_enabled')(framework, check_id)) }}
{% endmacro %}

{% macro snowflake__elasticsearch_domains_should_have_encryption_at_rest_enabled(framework, check_id) %}
select
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'Elasticsearch domains should have encryption at rest enabled' as title,
  account_id,
  arn as resource_id,
  case when
        (encryption_at_rest_options:Enabled)::boolean is distinct from true
    then 'fail'
    else 'pass'
  end as status
from aws_elasticsearch_domains
{% endmacro %}

{% macro postgres__elasticsearch_domains_should_have_encryption_at_rest_enabled(framework, check_id) %}
select
  '{{framework}}' as framework,
  '{{check_id}}' as check_id,
  'Elasticsearch domains should have encryption at rest enabled' as title,
  account_id,
  arn as resource_id,
  case when
        (encryption_at_rest_options->>'Enabled')::boolean is not true
    then 'fail'
    else 'pass'
  end as status
from aws_elasticsearch_domains
{% endmacro %}
