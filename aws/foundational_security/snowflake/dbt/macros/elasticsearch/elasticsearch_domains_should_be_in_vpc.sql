{% macro elasticsearch_domains_should_be_in_vpc(framework, check_id) %}
insert into aws_policy_results
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