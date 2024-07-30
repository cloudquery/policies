{% macro policies_with_admin_rights(framework, check_id) %}
  {{ return(adapter.dispatch('policies_with_admin_rights')(framework, check_id)) }}
{% endmacro %}

{% macro snowflake__policies_with_admin_rights(framework, check_id) %}
with pvs as (
    select
        p.id,
        pv.document_json as document
    from aws_iam_policies p
    inner join aws_iam_policy_default_versions pv on pv._cq_parent_id = p._cq_id
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
          and action.value = '*'
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

{% macro postgres__policies_with_admin_rights(framework, check_id) %}
with pvs as (
    select
        p.id,
        pv.document_json as document
    from aws_iam_policies p
    inner join aws_iam_policy_default_versions pv on pv._cq_parent_id = p._cq_id
	where pv.is_default_version = true and p.arn not like 'arn:aws:iam::aws:policy%'
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
    where 
	(action = '*'
        or action like '%"*"%')
        and statement ->> 'Effect' = 'Allow'
        and (resource = '*'
            or resource like '%"*"%')
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

{% macro default__policies_with_admin_rights(framework, check_id) %}{% endmacro %}

{% macro bigquery__policies_with_admin_rights(framework, check_id) %}
with pvs as (
    select
        p.id,
        pv.document_json as document
    from {{ full_table_name("aws_iam_policies") }} p
    inner join {{ full_table_name("aws_iam_policy_default_versions") }} pv on pv._cq_parent_id = p._cq_id
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
          and JSON_VALUE(action) = '*'
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

{% macro athena__policies_with_admin_rights(framework, check_id) %}
select * from (
WITH iam_policies AS (
    SELECT
        p.id AS id,
        p.account_id,
        p.arn,
        CASE 
    WHEN json_array_length(json_extract(pv.document_json, '$.Statement')) IS NULL THEN
      json_parse('[' || json_extract_scalar(pv.document_json, '$.Statement') || ']')
    ELSE
      json_extract(pv.document_json, '$.Statement')
  END AS statement
    FROM aws_iam_policies p
    JOIN aws_iam_policy_default_versions pv ON pv._cq_parent_id = p._cq_id
    WHERE pv.is_default_version = TRUE and p.arn not like 'arn:aws:iam::aws:policy%'
),
policy_statements AS (
    SELECT
        id,
        account_id,
        arn,
        t.statement,
        CASE 
        WHEN json_array_length(json_extract(t.statement, '$.Resource')) IS NULL THEN
          json_parse('["' || json_extract_scalar(t.statement, '$.Resource') || '"]')
        ELSE
          json_extract(t.statement, '$.Resource')
      END AS resource_fixed,
      CASE 
        WHEN json_array_length(json_extract(t.statement, '$.Action')) IS NULL THEN
          json_parse('["' || json_extract_scalar(t.statement, '$.Action') || '"]')
        ELSE
          json_extract(t.statement, '$.Action')
      END AS action_fixed
    FROM iam_policies
    CROSS JOIN UNNEST(CAST(statement AS array(json))) AS t(statement)
),
allow_all_statements AS (
    SELECT
        id,
        account_id,
        arn,
        CASE 
        WHEN json_array_length(json_extract(statement, '$.Resource')) IS NULL THEN
          json_parse('["' || json_extract_scalar(statement, '$.Resource') || '"]')
        ELSE
          json_extract(statement, '$.Resource')
      END AS resource_fixed,
      CASE 
        WHEN json_array_length(json_extract(statement, '$.Action')) IS NULL THEN
          json_parse('["' || json_extract_scalar(statement, '$.Action') || '"]')
        ELSE
          json_extract(statement, '$.Action')
      END AS action_fixed
    FROM policy_statements,
    UNNEST(CAST(resource_fixed as array(varchar))) t(resource),
        UNNEST(CAST(action_fixed as array(varchar))) t(action)
    WHERE 
        ((JSON_EXTRACT_SCALAR(statement, '$.Effect') = '"Allow"'
        or JSON_EXTRACT_SCALAR(statement, '$.Effect') = 'Allow'))
    AND
        ( action = '*' or action LIKE '%"*"%' )
    AND 
        (resource = '*' or resource LIKE '%"*"%')
)
SELECT distinct
    '{{framework}}' AS framework,
    '{{check_id}}' AS check_id,
    'IAM policies should not allow full * administrative privileges' AS title,
    p.account_id,
    p.arn AS resource_id,
    CASE WHEN b.id IS NOT NULL THEN 'fail' ELSE 'pass' END AS status
FROM aws_iam_policies p
LEFT JOIN allow_all_statements b ON p.id = b.id
)
{% endmacro %}
