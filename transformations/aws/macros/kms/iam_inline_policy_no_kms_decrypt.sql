{% macro iam_inline_policy_no_kms_decrypt(framework, check_id) %}
  {{ return(adapter.dispatch('iam_inline_policy_no_kms_decrypt')(framework, check_id)) }}
{% endmacro %}

{% macro default__iam_inline_policy_no_kms_decrypt(framework, check_id) %}{% endmacro %}

{% macro postgres__iam_inline_policy_no_kms_decrypt(framework, check_id) %}
WITH pdu AS (
    SELECT
        u.user_arn as arn,
        u.account_id as account_id,
        CASE 
            WHEN jsonb_typeof(u.policy_document->'Statement') = 'array' THEN
                u.policy_document->'Statement'
            ELSE
                jsonb_build_array(u.policy_document->'Statement')
        END AS statement_fixed
    FROM aws_iam_user_policies u
),
pdr AS (
    SELECT
        r.role_arn as arn,
        r.account_id as account_id,
        CASE 
            WHEN jsonb_typeof(r.policy_document->'Statement') = 'array' THEN
                r.policy_document->'Statement'
            ELSE
                jsonb_build_array(r.policy_document->'Statement')
        END AS statement_fixed
    FROM aws_iam_role_policies r
),
pdg AS (
    SELECT
        g.group_arn as arn,
        g.account_id as account_id,
        CASE 
            WHEN jsonb_typeof(g.policy_document->'Statement') = 'array' THEN
                g.policy_document->'Statement'
            ELSE
                jsonb_build_array(g.policy_document->'Statement')
        END AS statement_fixed
    FROM aws_iam_group_policies g
),
resources_actions AS (
    SELECT
        arn,
        account_id,
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
    FROM (
        SELECT * FROM pdu
        UNION ALL
        SELECT * FROM pdr
        UNION ALL
        SELECT * FROM pdg
    ) AS combined_policies,
    jsonb_array_elements(statement_fixed) AS statement
),
decrypt_policies AS (
    SELECT
        arn,
        COUNT(*) AS violations
    FROM resources_actions,
        jsonb_array_elements_text(resources) AS resource,
        jsonb_array_elements_text(actions) AS action
    WHERE statement_fixed->>'Effect' = 'Allow'
          AND (resource LIKE '%kms%' or resource = '*')
          AND (action = 'kms:Decrypt' OR action = 'kms:ReEncryptFrom')
    GROUP BY arn
)
SELECT
  '{{framework}}' AS framework,
  '{{check_id}}' AS check_id,
  'IAM principals should not have IAM inline policies that allow decryption actions on all KMS keys' AS title,
  u.account_id,
  u.arn AS resource_id,
  CASE
    WHEN dp.arn IS NOT NULL THEN 'fail'
    ELSE 'pass'
  END AS status
FROM (
    SELECT arn, account_id FROM aws_iam_users
    UNION ALL
    SELECT arn, account_id FROM aws_iam_roles WHERE arn NOT LIKE '%service-role/%'
    UNION ALL
    SELECT arn, account_id FROM aws_iam_groups
) AS u
LEFT JOIN decrypt_policies dp
    ON u.arn = dp.arn
{% endmacro %}

{% macro snowflake__iam_inline_policy_no_kms_decrypt(framework, check_id) %}
WITH pdu AS (
    SELECT
        u.user_arn AS arn,
        u.account_id AS account_id,
        CASE 
            WHEN ARRAY_SIZE(u.policy_document:Statement) IS NULL THEN
              PARSE_JSON('[' || u.policy_document:Statement || ']')
            ELSE
              u.policy_document:Statement
        END AS statements
    FROM aws_iam_user_policies u
),
pdr AS (
    SELECT
        r.role_arn AS arn,
        r.account_id AS account_id,
        CASE 
            WHEN ARRAY_SIZE(r.policy_document:Statement) IS NULL THEN
              PARSE_JSON('[' || r.policy_document:Statement || ']')
            ELSE
              r.policy_document:Statement
        END AS statements
    FROM aws_iam_role_policies r
),
pdg AS (
    SELECT
        g.group_arn AS arn,
        g.account_id AS account_id,
        CASE 
            WHEN ARRAY_SIZE(g.policy_document:Statement) IS NULL THEN
              PARSE_JSON('[' || g.policy_document:Statement || ']')
            ELSE
              g.policy_document:Statement
        END AS statements
    FROM aws_iam_group_policies g
),
resources_actions AS (
    SELECT
        arn,
        account_id,
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
    FROM (
        SELECT * FROM pdu
        UNION ALL
        SELECT * FROM pdr
        UNION ALL
        SELECT * FROM pdg
    ) AS combined_policies,
    LATERAL FLATTEN(combined_policies.statements) AS statement
),
decrypt_policies AS (
    SELECT
        arn,
        COUNT(*) AS violations
    FROM resources_actions,
        LATERAL FLATTEN(resources) AS resource,
        LATERAL FLATTEN(actions) AS action
    WHERE statements:Effect = 'Allow'
          AND (resource.value LIKE '%kms%' OR resource.value = '*')
          AND (action.value = 'kms:Decrypt' OR action.value = 'kms:ReEncryptFrom')
    GROUP BY arn
)
SELECT DISTINCT
  '{{framework}}' AS framework,
  '{{check_id}}' AS check_id,
  'IAM principals should not have IAM inline policies that allow decryption actions on all KMS keys' AS title,
  u.account_id,
  u.arn AS resource_id,
  CASE
    WHEN dp.arn IS NOT NULL THEN 'fail'
    ELSE 'pass'
  END AS status
FROM (
    SELECT arn, account_id FROM aws_iam_users
    UNION ALL
    SELECT arn, account_id FROM aws_iam_roles WHERE arn NOT LIKE '%service-role/%'
    UNION ALL
    SELECT arn, account_id FROM aws_iam_groups
) AS u
LEFT JOIN decrypt_policies dp
    ON u.arn = dp.arn
{% endmacro %}

{% macro bigquery__iam_inline_policy_no_kms_decrypt(framework, check_id) %}
 WITH pdu AS (
    SELECT
        u.user_arn AS arn,
        u.account_id AS account_id,
        CASE 
            WHEN JSON_TYPE(u.policy_document.Statement) != 'array' THEN
                PARSE_JSON(CONCAT('[', TO_JSON_STRING(u.policy_document.Statement), ']'))
            ELSE
                u.policy_document.Statement
        END AS statements
    FROM {{ full_table_name("aws_iam_user_policies") }} u
),
pdr AS (
    SELECT
        r.role_arn AS arn,
        r.account_id AS account_id,
        CASE 
            WHEN JSON_TYPE(r.policy_document.Statement) != 'array' THEN
                PARSE_JSON(CONCAT('[', TO_JSON_STRING(r.policy_document.Statement), ']'))
            ELSE
                r.policy_document.Statement
        END AS statements
    FROM {{ full_table_name("aws_iam_role_policies") }} r
),
pdg AS (
    SELECT
        g.group_arn AS arn,
        g.account_id AS account_id,
        CASE 
            WHEN JSON_TYPE(g.policy_document.Statement) != 'array' THEN
                PARSE_JSON(CONCAT('[', TO_JSON_STRING(g.policy_document.Statement), ']'))
            ELSE
                g.policy_document.Statement
        END AS statements
    FROM {{ full_table_name("aws_iam_group_policies") }} g
),
resources_actions AS (
    SELECT
        arn,
        account_id,
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
    FROM (
        SELECT * FROM pdu
        UNION ALL
        SELECT * FROM pdr
        UNION ALL
        SELECT * FROM pdg
    ) AS combined_policies,
    UNNEST(JSON_QUERY_ARRAY(statements)) AS statement
),
decrypt_policies AS (
    SELECT
        arn,
        COUNT(*) AS violations
    FROM resources_actions,
        UNNEST(JSON_QUERY_ARRAY(resources)) AS resource,
        UNNEST(JSON_QUERY_ARRAY(actions)) AS action
    WHERE JSON_VALUE(statements.Effect) = 'Allow'
          AND (JSON_VALUE(resource) = '*' OR JSON_VALUE(resource) LIKE '%kms%')
          AND (JSON_VALUE(action) = 'kms:Decrypt' OR JSON_VALUE(action) = 'kms:ReEncryptFrom')
    GROUP BY arn
)
SELECT DISTINCT
    '{{framework}}' AS framework,
    '{{check_id}}' AS check_id,
    'IAM policies should not allow full * administrative privileges' AS title,
    u.account_id,
    u.arn AS resource_id,
    CASE
    WHEN dp.arn IS NOT NULL THEN 'fail'
    ELSE 'pass'
    END AS status
FROM (
    SELECT arn, account_id FROM {{ full_table_name("aws_iam_users") }}
    UNION ALL
    SELECT arn, account_id FROM {{ full_table_name("aws_iam_roles") }} WHERE arn NOT LIKE '%service-role/%'
    UNION ALL
    SELECT arn, account_id FROM {{ full_table_name("aws_iam_groups") }}
) AS u
LEFT JOIN decrypt_policies dp
    ON u.arn = dp.arn
{% endmacro %}

{% macro athena__iam_inline_policy_no_kms_decrypt(framework, check_id) %}
select * from (
WITH decrypt_users AS (
    SELECT
        user_arn AS arn,
        CASE 
            WHEN json_array_length(json_extract(policy_document, '$.Statement')) IS NULL THEN
                json_parse('[' || json_extract_scalar(policy_document, '$.Statement') || ']')
            ELSE
                json_extract(policy_document, '$.Statement')
        END AS statement_fixed
    FROM aws_iam_user_policies
),
decrypt_users_resouce_action AS (
    SELECT
        arn,
        statement AS statement_fixed,
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
    FROM decrypt_users,
    UNNEST(CAST(statement_fixed AS ARRAY(JSON))) AS t(statement)
),
decrypt_users_violations AS (
    SELECT
        arn,
        COUNT(*) AS violations
    FROM decrypt_users_resouce_action,
        UNNEST(CAST(resource_fixed AS ARRAY(VARCHAR))) t(resource),
        UNNEST(CAST(action_fixed AS ARRAY(VARCHAR))) t(action)
    WHERE JSON_EXTRACT_SCALAR(statement_fixed, '$.Effect') = 'Allow'
          AND (resource = '*' OR resource LIKE '%kms%')
          AND (action = '*' OR action LIKE '%kms:*%' OR action LIKE '%kms:decrypt%' OR action LIKE '%kms:reencryptfrom%' OR action LIKE '%kms:reencrypt*%')
    GROUP BY arn
),
decrypt_roles AS (
    SELECT
        role_arn AS arn,
        CASE 
            WHEN json_array_length(json_extract(policy_document, '$.Statement')) IS NULL THEN
                json_parse('[' || json_extract_scalar(policy_document, '$.Statement') || ']')
            ELSE
                json_extract(policy_document, '$.Statement')
        END AS statement_fixed
    FROM aws_iam_role_policies
),
decrypt_roles_resouce_action AS (
    SELECT
        arn,
        statement AS statement_fixed,
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
    FROM decrypt_roles,
    UNNEST(CAST(statement_fixed AS ARRAY(JSON))) AS t(statement)
),
decrypt_roles_violations AS (
    SELECT
        arn,
        COUNT(*) AS violations
    FROM decrypt_roles_resouce_action,
        UNNEST(CAST(resource_fixed AS ARRAY(VARCHAR))) t(resource),
        UNNEST(CAST(action_fixed AS ARRAY(VARCHAR))) t(action)
    WHERE JSON_EXTRACT_SCALAR(statement_fixed, '$.Effect') = 'Allow'
          AND (resource = '*' OR resource LIKE '%kms%')
          AND (action = '*' OR action LIKE '%kms:*%' OR action LIKE '%kms:decrypt%' OR action LIKE '%kms:reencryptfrom%' OR action LIKE '%kms:reencrypt*%')
          AND arn NOT LIKE '%service-role/%'
    GROUP BY arn
),
decrypt_groups AS (
    SELECT
        gp.group_arn AS arn,
        CASE 
            WHEN json_array_length(json_extract(gp.policy_document, '$.Statement')) IS NULL THEN
                json_parse('[' || json_extract_scalar(gp.policy_document, '$.Statement') || ']')
            ELSE
                json_extract(gp.policy_document, '$.Statement')
        END AS statement_fixed
    FROM aws_iam_group_policies gp
),
decrypt_groups_resource_action AS (
    SELECT
        arn,
        statement AS statement_fixed,
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
    FROM decrypt_groups,
    UNNEST(CAST(statement_fixed AS ARRAY(JSON))) AS t(statement)
),
decrypt_groups_violations AS (
    SELECT
        arn,
        COUNT(*) AS violations
    FROM decrypt_groups_resource_action,
        UNNEST(CAST(resource_fixed AS ARRAY(VARCHAR))) t(resource),
        UNNEST(CAST(action_fixed AS ARRAY(VARCHAR))) t(action)
    WHERE JSON_EXTRACT_SCALAR(statement_fixed, '$.Effect') = 'Allow'
          AND (resource = '*' OR resource LIKE '%kms%')
          AND (action = '*' OR action LIKE '%kms:*%' OR action LIKE '%kms:decrypt%' OR action LIKE '%kms:reencryptfrom%' OR action LIKE '%kms:reencrypt*%')
          AND arn NOT LIKE '%service-role/%'
    GROUP BY arn
)
SELECT
    '{{framework}}' AS framework,
    '{{check_id}}' AS check_id,
    'IAM principals should not have IAM inline policies that allow decryption actions on all KMS keys' AS title,
    u.account_id,
    u.arn AS resource_id,
    CASE 
        WHEN v.arn IS NOT NULL AND v.violations > 0 THEN 'fail'
        ELSE 'pass'
    END AS status
FROM aws_iam_users u
LEFT JOIN decrypt_users_violations v ON v.arn = u.arn

UNION ALL

SELECT
    '{{framework}}' AS framework,
    '{{check_id}}' AS check_id,
    'IAM principals should not have IAM inline policies that allow decryption actions on all KMS keys' AS title,
    r.account_id,
    r.arn AS resource_id,
    CASE 
        WHEN v.arn IS NOT NULL AND v.violations > 0 THEN 'fail'
        ELSE 'pass'
    END AS status
FROM aws_iam_roles r
LEFT JOIN decrypt_roles_violations v ON v.arn = r.arn

UNION ALL

SELECT
    '{{framework}}' AS framework,
    '{{check_id}}' AS check_id,
    'IAM principals should not have IAM inline policies that allow decryption actions on all KMS keys' AS title,
    g.account_id,
    g.arn AS resource_id,
    CASE 
        WHEN v.arn IS NOT NULL AND v.violations > 0 THEN 'fail'
        ELSE 'pass'
    END AS status
FROM aws_iam_groups g
LEFT JOIN decrypt_groups_violations v ON v.arn = g.arn
)
{% endmacro %}