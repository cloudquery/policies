{% macro documents_should_not_be_public(framework, check_id) %}
  {{ return(adapter.dispatch('documents_should_not_be_public')(framework, check_id)) }}
{% endmacro %}

{% macro snowflake__documents_should_not_be_public(framework, check_id) %}
select
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'SSM documents should not be public' as title,
    account_id,
    arn as resource_id,
    case when ARRAY_CONTAINS('all'::variant, p.value:AccountIds::ARRAY) then 'fail' else 'pass' end as status
from aws_ssm_documents, lateral flatten(input => parse_json(aws_ssm_documents.permissions)) as p
where owner in (select account_id from aws_iam_accounts)
{% endmacro %}

{% macro postgres__documents_should_not_be_public(framework, check_id) %}
select
    '{{framework}}' as framework,
    '{{check_id}}' as check_id,
    'SSM documents should not be public' as title,
    account_id,
    arn as resource_id,
    case when
        'all' = ANY(ARRAY(SELECT JSONB_ARRAY_ELEMENTS_TEXT(p->'AccountIds'))) 
    then 'fail' else 'pass' end as status
from aws_ssm_documents, jsonb_array_elements(aws_ssm_documents.permissions) p
where owner in (select account_id from aws_iam_accounts)
{% endmacro %}

{% macro default__documents_should_not_be_public(framework, check_id) %}{% endmacro %}

{% macro bigquery__documents_should_not_be_public(framework, check_id) %}
select
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'SSM documents should not be public' as title,
    account_id,
    arn as resource_id,
    case when 'all' IN UNNEST(JSON_EXTRACT_STRING_ARRAY(p.AccountIds)) then 'fail' else 'pass' end as status
from {{ full_table_name("aws_ssm_documents") }},
  UNNEST(JSON_QUERY_ARRAY(aws_ssm_documents.permissions)) AS p
where owner in (select account_id from {{ full_table_name("aws_iam_accounts") }})
{% endmacro %}

{% macro athena__documents_should_not_be_public(framework, check_id) %}
select
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'SSM documents should not be public' as title,
    account_id,
    arn as resource_id,
    case when CONTAINS(cast(json_extract(perms, '$.AccountIds') as array(varchar)), 'all') then 'fail' else 'pass' end as status
from aws_ssm_documents, unnest(cast(json_parse(aws_ssm_documents.permissions) as array(json))) as t(perms)
where owner in (select account_id from aws_iam_accounts)
{% endmacro %}