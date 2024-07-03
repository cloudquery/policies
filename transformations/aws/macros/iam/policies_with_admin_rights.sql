{% macro policies_with_admin_rights(framework, check_id) %}
  {{ return(adapter.dispatch('policies_with_admin_rights')(framework, check_id)) }}
{% endmacro %}

{% macro snowflake__policies_with_admin_rights(framework, check_id) %}
with bad_statements as (
SELECT
    p.id
FROM
    aws_iam_policies p
    INNER JOIN aws_iam_policy_versions pv ON pv._cq_parent_id = p._cq_id
    , lateral flatten(input => pv.document_json:Statement) as s
where pv.is_default_version = 'true' AND s.value:Effect = 'Allow'
    and s.value:Effect = 'Allow'
            and (s.value:Action = '*' or s.value:Action = '*:*')
            and s.value:Resource = '*'
)
select
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'IAM policies should not allow full * administrative privileges' as title,
    account_id,
    arn as resource_id,
    CASE
        WHEN b.id is not null THEN 'fail'
        ELSE 'pass'
    END as status
from
    aws_iam_policies as p
LEFT JOIN bad_statements as b
    ON p.id = b.id
WHERE p.arn REGEXP '.*\d{12}.*'
{% endmacro %}

{% macro postgres__policies_with_admin_rights(framework, check_id) %}
with iam_policies as (
    select
        p.id as id,
        pv.document_json as document
    from aws_iam_policies p
    inner join aws_iam_policy_versions pv ON pv._cq_parent_id = p._cq_id
    where pv.is_default_version = true and p.arn not like 'arn:aws:iam::aws:policy%'
),
policy_statements as (
    select
        id,
        JSONB_ARRAY_ELEMENTS(
            case JSONB_TYPEOF(document -> 'Statement')
                when 'string' then JSONB_BUILD_ARRAY(document ->> 'Statement')
                when 'array' then document -> 'Statement' end
        ) as statement
    from
        iam_policies
),
allow_all_statements as (
    select
        id,
        COUNT(statement) as statements_count
    from policy_statements
    where (statement ->> 'Action' = '*'
        or statement ->> 'Action' like '%"*"%')
        and statement ->> 'Effect' = 'Allow'
        and (statement ->> 'Resource' = '*'
            or statement ->> 'Resource' like '%"*"%')
    group by id
)

select distinct
    '{{framework}}' as framework,
    '{{check_id}}' as check_id,
    'IAM policies should not allow full ''*'' administrative privileges' as title,
    aws_iam_policies.account_id,
    aws_iam_policies.arn AS resource_id,
    CASE WHEN statements_count > 0 THEN 'fail' ELSE 'pass' END AS status
from aws_iam_policies
left join
    allow_all_statements on aws_iam_policies.id = allow_all_statements.id
{% endmacro %}

{% macro default__policies_with_admin_rights(framework, check_id) %}{% endmacro %}

{% macro bigquery__policies_with_admin_rights(framework, check_id) %}
with bad_statements as (
SELECT
    p.id
FROM
    {{ full_table_name("aws_iam_policies") }} p
    INNER JOIN {{ full_table_name("aws_iam_policy_versions") }} pv 
    ON pv._cq_parent_id = p._cq_id, 
    UNNEST(JSON_QUERY_ARRAY(pv.document_json.Statement)) AS s
where pv.is_default_version = true AND JSON_VALUE(s.Effect) = 'Allow'
    and JSON_VALUE(s.Effect) = 'Allow'
            and (JSON_VALUE(s.Action) = '*' or JSON_VALUE(s.Action) = '*:*')
            and JSON_VALUE(s.Resource) = '*'
)
select
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'IAM policies should not allow full * administrative privileges' as title,
    account_id,
    arn as resource_id,
    CASE
        WHEN b.id is not null THEN 'fail'
        ELSE 'pass'
    END as status
from
    {{ full_table_name("aws_iam_policies") }} as p
LEFT JOIN bad_statements as b
    ON p.id = b.id
WHERE REGEXP_CONTAINS(p.arn, r'.*\d{12}.*')
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
    JOIN aws_iam_policy_versions pv ON pv._cq_parent_id = p._cq_id
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
