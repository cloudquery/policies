{% macro policies_have_wildcard_actions(framework, check_id) %}
  {{ return(adapter.dispatch('policies_have_wildcard_actions')(framework, check_id)) }}
{% endmacro %}

{% macro default__policies_have_wildcard_actions(framework, check_id) %}{% endmacro %}

{% macro postgres__policies_have_wildcard_actions(framework, check_id) %}
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
),
resources_actions AS (
    SELECT
        id,
        statement AS statement_fixed,
        CASE 
            WHEN jsonb_typeof(statement->'NotAction') = 'array' THEN
                statement->'NotAction'
            ELSE
                jsonb_build_array(statement->'NotAction')
        END AS not_actions,
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
        jsonb_array_elements_text(not_actions) AS not_action,
        jsonb_array_elements_text(actions) AS action
    WHERE statement_fixed->>'Effect' = 'Allow'
          AND (action like '%:*'
		  OR not_action like '%:*')
    GROUP BY id
)
SELECT DISTINCT
    '{{framework}}' AS framework,
    '{{check_id}}' AS check_id,
    'IAM customer managed policies that you create should not allow wildcard actions for services' as title,
    p.account_id,
    p.arn AS resource_id,
    CASE WHEN
        v.id IS NOT NULL AND v.violations > 0
    THEN 'fail' ELSE 'pass' END AS status
FROM aws_iam_policies p
LEFT JOIN violations v ON v.id = p.id
{% endmacro %}

{% macro snowflake__policies_have_wildcard_actions(framework, check_id) %}
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
),
t_actions AS (
    SELECT
        id,
        statement.value AS statements,
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
    FROM t_actions,
        LATERAL FLATTEN(actions) AS action
    WHERE statements:Effect = 'Allow'
          AND action.value like '%:*'
    GROUP BY id
)
SELECT DISTINCT
    '{{framework}}' AS framework,
    '{{check_id}}' AS check_id,
    'IAM customer managed policies that you create should not allow wildcard actions for services' as title,
    account_id,
    arn AS resource_id,
    CASE WHEN
        violations.id IS NOT NULL AND violations.violations > 0
    THEN 'fail' ELSE 'pass' END AS status
FROM aws_iam_policies
LEFT JOIN violations ON violations.id = aws_iam_policies.id
{% endmacro %}

{% macro bigquery__policies_have_wildcard_actions(framework, check_id) %}
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
),
t_actions AS (
    SELECT
        id,
        statement AS statements,
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
    FROM t_actions,
        UNNEST(JSON_QUERY_ARRAY(actions)) AS action
    WHERE JSON_VALUE(statements.Effect) = 'Allow'
          AND JSON_VALUE(action) like '%:*'
    GROUP BY id
)
SELECT DISTINCT
    '{{framework}}' AS framework,
    '{{check_id}}' AS check_id,
    'IAM customer managed policies that you create should not allow wildcard actions for services' as title,
    p.account_id,
    p.arn AS resource_id,
    CASE WHEN
        v.id IS NOT NULL AND v.violations > 0
    THEN 'fail' ELSE 'pass' END AS status
FROM {{ full_table_name("aws_iam_policies") }} p
LEFT JOIN violations v ON v.id = p.id
{% endmacro %}

{% macro athena__policies_have_wildcard_actions(framework, check_id) %}
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
        WHEN json_array_length(json_extract(t.statement, '$.Action')) IS NULL THEN
          json_parse('["' || json_extract_scalar(t.statement, '$.Action') || '"]')
        ELSE
          json_extract(t.statement, '$.Action')
      END AS action_fixed
    FROM iam_policies
    CROSS JOIN UNNEST(CAST(statement AS array(json))) AS t(statement)
),
bad_statements AS (
    SELECT
        ps.account_id,
        ps.arn AS resource_id,
        CASE
            WHEN action LIKE '%:*'
                OR action = '*' THEN 1
            ELSE 0
        END AS status
    FROM
        policy_statements ps,
        UNNEST(CAST(action_fixed as array(varchar))) t(action)
    WHERE JSON_EXTRACT_SCALAR(ps.statement, '$.Effect') = 'Allow'
)
SELECT DISTINCT
    '{{framework}}' AS framework,
    '{{check_id}}' AS check_id,
    'IAM customer managed policies that you create should not allow wildcard actions for services' AS title,
    account_id,
    resource_id,
    CASE
        WHEN MAX(status) OVER(PARTITION BY resource_id) = 1 THEN 'fail'
        ELSE 'pass'
    END AS status
FROM
    bad_statements
)
{% endmacro %}
