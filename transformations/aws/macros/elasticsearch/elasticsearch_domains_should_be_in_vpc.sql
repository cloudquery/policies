{% macro elasticsearch_domains_should_be_in_vpc(framework, check_id) %}
  {{ return(adapter.dispatch('elasticsearch_domains_should_be_in_vpc')(framework, check_id)) }}
{% endmacro %}

{% macro snowflake__elasticsearch_domains_should_be_in_vpc(framework, check_id) %}
select
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'Elasticsearch domains should be in a VPC' as title,
  account_id,
  arn as resource_id,
  case when
    vpc_options:VPCId is null
    then 'fail'
    else 'pass'
  end as status
from aws_elasticsearch_domains
{% endmacro %}

{% macro postgres__elasticsearch_domains_should_be_in_vpc(framework, check_id) %}
select
  '{{framework}}' as framework,
  '{{check_id}}' as check_id,
  'Elasticsearch domains should be in a VPC' as title,
  account_id,
  arn as resource_id,
  case when
    vpc_options->>'VPCId' is null
    then 'fail'
    else 'pass'
  end as status
from aws_elasticsearch_domains
{% endmacro %}

{% macro default__elasticsearch_domains_should_be_in_vpc(framework, check_id) %}{% endmacro %}
                    