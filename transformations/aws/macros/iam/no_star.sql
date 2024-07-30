{% macro no_star(framework, check_id) %}
  {{ return(adapter.dispatch('no_star')(framework, check_id)) }}
{% endmacro %}

{% macro default__no_star(framework, check_id) %}{% endmacro %}

{% macro postgres__no_star(framework, check_id) %}
WITH pvs AS (
    SELECT
        p.id AS id,
        CASE 
            WHEN jsonb_typeof(pv.document_json->'Statement') = 'array' THEN
                pv.document_json->'Statement'
            ELSE
                jsonb_build_array(pv.document_json->'Statement')
        END AS statement_fixed
    FROM aws_iam_policies p
    JOIN aws_iam_policy_default_versions pv ON pv._cq_parent_id = p._cq_id
    WHERE p.arn not like 'arn:aws:iam::aws:policy%'
),
resources_actions AS (
    SELECT
        id,
        statement AS statement_fixed,
        CASE 
            WHEN jsonb_typeof(statement->'Resource') = 'array' THEN
                statement->'Resource'
            ELSE
                jsonb_build_array(statement->'Resource')
        END AS resources,
        CASE 
            WHEN jsonb_typeof(statement->'Action') = 'array' THEN
                statement->'Action'
            ELSE
                jsonb_build_array(statement->'Action')
        END AS actions
    FROM pvs,
    jsonb_array_elements(statement_fixed) AS statement
),
violations AS (
    SELECT
        id,
        COUNT(*) AS violations
    FROM resources_actions,
        jsonb_array_elements_text(resources) AS resource,
        jsonb_array_elements_text(actions) AS action
    WHERE statement_fixed->>'Effect' = 'Allow'
          AND resource = '*'
          AND (action = '*' OR action = '*:*')
    GROUP BY id
)
SELECT DISTINCT
    '{{framework}}' AS framework,
    '{{check_id}}' AS check_id,
    'IAM policies should not allow full ''*'' administrative privileges' AS title,
    p.account_id,
    p.arn AS resource_id,
    CASE WHEN
        v.id IS NOT NULL AND v.violations > 0
    THEN 'fail' ELSE 'pass' END AS status
FROM aws_iam_policies p
LEFT JOIN violations v ON v.id = p.id
{% endmacro %}

{% macro bigquery__no_star(framework, check_id) %}
WITH pvs AS (
    SELECT
        p.id AS id,
        CASE 
            WHEN JSON_TYPE(pv.document_json.Statement) != 'array' THEN
                PARSE_JSON(CONCAT('[', TO_JSON_STRING(pv.document_json.Statement), ']'))
            ELSE
                pv.document_json.Statement
        END AS statements
    FROM {{ full_table_name("aws_iam_policies") }} p
    JOIN {{ full_table_name("aws_iam_policy_default_versions") }} pv ON pv._cq_parent_id = p._cq_id
    WHERE p.arn not like 'arn:aws:iam::aws:policy%'
),
resources_actions AS (
    SELECT
        id,
        statement AS statements,
        CASE 
            WHEN JSON_TYPE(JSON_EXTRACT(statement, '$.Resource')) != 'array' THEN
                PARSE_JSON(CONCAT('[', TO_JSON_STRING(statement.Resource), ']'))
            ELSE
                statement.Resource
        END AS resources,
        CASE 
            WHEN JSON_TYPE(JSON_EXTRACT(statement, '$.Action')) != 'array' THEN
                PARSE_JSON(CONCAT('[', TO_JSON_STRING(statement.Action), ']'))
            ELSE
                statement.Action
        END AS actions
    FROM pvs,
    UNNEST(JSON_QUERY_ARRAY(statements)) AS statement
),
violations AS (
    SELECT
        id,
        COUNT(*) AS violations
    FROM resources_actions,
        UNNEST(JSON_QUERY_ARRAY(resources)) AS resource,
        UNNEST(JSON_QUERY_ARRAY(actions)) AS action
    WHERE JSON_VALUE(statements.Effect) = 'Allow'
          AND JSON_VALUE(resource) = '*'
          AND (JSON_VALUE(action) = '*' OR JSON_VALUE(action) = '*:*')
    GROUP BY id
)
SELECT DISTINCT
    '{{framework}}' AS framework,
    '{{check_id}}' AS check_id,
    'IAM policies should not allow full * administrative privileges' AS title,
    p.account_id,
    p.arn AS resource_id,
    CASE WHEN
        v.id IS NOT NULL AND v.violations > 0
    THEN 'fail' ELSE 'pass' END AS status
FROM {{ full_table_name("aws_iam_policies") }} p
LEFT JOIN violations v ON v.id = p.id
{% endmacro %}

{% macro snowflake__no_star(framework, check_id) %}
WITH pvs AS (
    SELECT
        p.id AS id,
        CASE 
            WHEN ARRAY_SIZE(pv.document_json:Statement) IS NULL THEN
              PARSE_JSON('[' || pv.document_json:Statement || ']')
            ELSE
              pv.document_json:Statement
          END AS statements
    FROM aws_iam_policies p
    JOIN aws_iam_policy_default_versions pv ON pv._cq_parent_id = p._cq_id
    WHERE p.arn not like 'arn:aws:iam::aws:policy%'
),
resources_actions AS (
    SELECT
        id,
        statement.value AS statements,
        CASE 
            WHEN ARRAY_SIZE(statement.value:Resource) IS NULL THEN
                PARSE_JSON('["' || statement.value:Resource || '"]')
            ELSE
                statement.value:Resource
        END AS resources,
        CASE 
            WHEN ARRAY_SIZE(statement.value:Action) IS NULL THEN
                PARSE_JSON('["' || statement.value:Action || '"]')
            ELSE
                statement.value:Action
        END AS actions
    FROM pvs,
    LATERAL FLATTEN(statements) AS statement
),
violations AS (
    SELECT
        id,
        COUNT(*) AS violations
    FROM resources_actions,
        LATERAL FLATTEN(resources) AS resource,
        LATERAL FLATTEN(actions) AS action
    WHERE statements:Effect = 'Allow'
          AND resource.value = '*'
          AND (action.value = '*' OR action.value = '*:*')
    GROUP BY id
)
SELECT DISTINCT
    '{{framework}}' AS framework,
    '{{check_id}}' AS check_id,
    'IAM policies should not allow full ''*'' administrative privileges' AS title,
    account_id,
    arn AS resource_id,
    CASE WHEN
        violations.id IS NOT NULL AND violations.violations > 0
    THEN 'fail' ELSE 'pass' END AS status
FROM aws_iam_policies
LEFT JOIN violations ON violations.id = aws_iam_policies.id
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
    JOIN aws_iam_policy_default_versions pv ON pv._cq_parent_id = p._cq_id
    WHERE p.arn not like 'arn:aws:iam::aws:policy%'
),
fix_resouce_action as (
    SELECT
      id,
      statement as statement_fixed,
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
    FROM pvs,
    UNNEST(CAST(statement_fixed as array(json))) as t(statement)
),
violations as (
    select
        id,
        COUNT(*) as violations
    from fix_resouce_action,
        UNNEST(CAST(resource_fixed as array(varchar))) t(resource),
        UNNEST(CAST(action_fixed as array(varchar))) t(action)
    where JSON_EXTRACT_SCALAR(statement_fixed, '$.Effect') = 'Allow'
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