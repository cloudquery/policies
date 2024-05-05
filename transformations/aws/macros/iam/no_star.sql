{% macro no_star(framework, check_id) %}
  {{ return(adapter.dispatch('no_star')(framework, check_id)) }}
{% endmacro %}

{% macro default__no_star(framework, check_id) %}{% endmacro %}

{% macro postgres__no_star(framework, check_id) %}

with pvs as (
    select
        p.id,
        pv.document_json as document
    from aws_iam_policies p
    inner join aws_iam_policy_versions pv on pv._cq_parent_id = p._cq_id
), violations as (
    select
        id,
        COUNT(*) as violations
    from pvs,
        JSONB_ARRAY_ELEMENTS(
            case JSONB_TYPEOF(document -> 'Statement')
                when 'string' then JSONB_BUILD_ARRAY(document ->> 'Statement')
                when 'array' then document -> 'Statement'
            end
        ) as statement,
        JSONB_ARRAY_ELEMENTS_TEXT(
            case JSONB_TYPEOF(statement -> 'Resource')
                when 'string' then JSONB_BUILD_ARRAY(statement ->> 'Resource')
                when 'array' then statement -> 'Resource' end
        ) as resource,
        JSONB_ARRAY_ELEMENTS_TEXT( case JSONB_TYPEOF(statement -> 'Action')
                when 'string' then JSONB_BUILD_ARRAY(statement ->> 'Action')
                when 'array' then statement -> 'Action' end
        ) as action
    where statement ->> 'Effect' = 'Allow'
          and resource = '*'
          and ( action = '*' or action = '*:*' )
    group by id
)

select distinct
    '{{framework}}' as framework,
    '{{check_id}}' as check_id,
    'IAM policies should not allow full ''*'' administrative privileges' as title,
    account_id,
    arn AS resource_id,
    case when
        violations.id is not null AND violations.violations > 0
    then 'fail' else 'pass' end as status
from aws_iam_policies
left join violations on violations.id = aws_iam_policies.id
{% endmacro %}

{% macro bigquery__no_star(framework, check_id) %}
with pvs as (
    select
        p.id,
        pv.document_json as document
    from {{ full_table_name("aws_iam_policies") }} p
    inner join {{ full_table_name("aws_iam_policy_versions") }} pv on pv._cq_parent_id = p._cq_id
), violations as (
    select
        id,
        COUNT(*) as violations
    from pvs,
    UNNEST(JSON_QUERY_ARRAY(document.Statement)) AS statement,
    UNNEST(JSON_QUERY_ARRAY(statement.Resource)) AS resource,
    UNNEST(JSON_QUERY_ARRAY(statement.Action)) AS action
    where JSON_VALUE(statement.Effect) = 'Allow'
          and JSON_VALUE(resource) = '*'
          and ( JSON_VALUE(action.value) = '*' or JSON_VALUE(action.value) = '*:*' )
    group by id
)

select distinct
    '{{framework}}' as framework,
    '{{check_id}}' as check_id,
    CONCAT('IAM policies should not allow full ', '''*''', ' administrative privileges') AS title,
    account_id,
    arn AS resource_id,
    case when
        violations.id is not null AND violations.violations > 0
    then 'fail' else 'pass' end as status
from {{ full_table_name("aws_iam_policies") }}
left join violations on violations.id = aws_iam_policies.id
{% endmacro %}

{% macro snowflake__no_star(framework, check_id) %}
with pvs as (
    select
        p.id,
        pv.document_json as document
    from aws_iam_policies p
    inner join aws_iam_policy_versions pv on pv._cq_parent_id = p._cq_id
), violations as (
    select
        id,
        COUNT(*) as violations
    from pvs,
        LATERAL FLATTEN(document:Statement) as statement,
        LATERAL FLATTEN(statement.value:Resource) as resource,
        LATERAL FLATTEN(statement.value:Action) as action
    where statement.value:Effect = 'Allow'
          and resource.value = '*'
          and ( action.value = '*' or action.value = '*:*' )
    group by id
)

select distinct
    '{{framework}}' as framework,
    '{{check_id}}' as check_id,
    'IAM policies should not allow full ''*'' administrative privileges' as title,
    account_id,
    arn AS resource_id,
    case when
        violations.id is not null AND violations.violations > 0
    then 'fail' else 'pass' end as status
from aws_iam_policies
left join violations on violations.id = aws_iam_policies.id
{% endmacro %}

{% macro athena__no_star(framework, check_id) %}
select * from (
WITH pvs AS (
    SELECT
        p.id AS id,
        CASE 
    WHEN json_array_length(json_extract(pv.document_json, '$.Statement')) IS NULL THEN
      json_parse('[' || json_extract_scalar(pv.document_json, '$.Statement') || ']')
    ELSE
      json_extract(pv.document_json, '$.Statement')
  END AS statement_fixed
    FROM aws_iam_policies p
    JOIN aws_iam_policy_versions pv ON pv._cq_parent_id = p._cq_id
),
fix_resouce_action as (
    SELECT
    id,
    statement_fixed,
    CASE 
    WHEN json_array_length(json_extract(statement_fixed, '$.Resource')) IS NULL THEN
      json_parse('[' || json_extract_scalar(statement_fixed, '$.Resource') || ']')
    ELSE
      json_extract(statement_fixed, '$.Resource')
  END AS resource_fixed,
  CASE 
    WHEN json_array_length(json_extract(statement_fixed, '$.Action')) IS NULL THEN
      json_parse('[' || json_extract_scalar(statement_fixed, '$.Action') || ']')
    ELSE
      json_extract(statement_fixed, '$.Action')
  END AS action_fixed
  FROM pvs
    
),
violations as (
    select
        id,
        COUNT(*) as violations
    from fix_resouce_action,
        UNNEST(CAST(statement_fixed as array(json))) as t(statement),
        UNNEST(CAST(resource_fixed as array(varchar))) t(resource),
        UNNEST(CAST(action_fixed as array(varchar))) t(action)
    where JSON_EXTRACT_SCALAR(statement, '$.Effect') = 'Allow'
          and resource = '*'
          and ( action = '*' or action = '*:*' )
    group by id
)
select distinct
    '{{framework}}' as framework,
    '{{check_id}}' as check_id,
    'IAM policies should not allow full ''*'' administrative privileges' as title,
    account_id,
    arn AS resource_id,
    case when
        violations.id is not null AND violations.violations > 0
    then 'fail' else 'pass' end as status
from aws_iam_policies
left join violations on violations.id = aws_iam_policies.id
)
{% endmacro %}