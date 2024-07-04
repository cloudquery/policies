{% macro iam_customer_policy_no_kms_decrypt(framework, check_id) %}
  {{ return(adapter.dispatch('iam_customer_policy_no_kms_decrypt')(framework, check_id)) }}
{% endmacro %}

{% macro default__iam_customer_policy_no_kms_decrypt(framework, check_id) %}{% endmacro %}

{% macro postgres__iam_customer_policy_no_kms_decrypt(framework, check_id) %}
WITH policy_with_decrypt AS (
    SELECT DISTINCT arn
    FROM aws_iam_policies p
    INNER JOIN aws_iam_policy_versions pv ON pv._cq_parent_id = p._cq_id
    , JSONB_ARRAY_ELEMENTS(pv.document_json -> 'Statement') as s
    WHERE
        s ->> 'Effect' = 'Allow'
        AND
        (s ->> 'Resource' = '*' OR
        s ->> 'Resource' LIKE '%kms%')
        AND 
        (s ->> 'Action' = '*'
         OR s ->> 'Action' LIKE '%kms:*%'
         OR s ->> 'Action' LIKE '%kms:decrypt%'
         OR s ->> 'Action' LIKE '%kms:reencryptfrom%'
         OR s ->> 'Action' LIKE '%kms:reencrypt*%')
)
SELECT
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'IAM customer managed policies should not allow decryption actions on all KMS keys' AS title,
  i.account_id,
    i.arn AS resource_id,
    CASE 
        WHEN d.arn IS NULL THEN 'pass'
        ELSE 'fail'
    END AS status
FROM    
    aws_iam_policies i
LEFT JOIN policy_with_decrypt d ON i.arn = d.arn
{% endmacro %}

{% macro snowflake__iam_customer_policy_no_kms_decrypt(framework, check_id) %}
WITH policy_with_decrypt AS (
    SELECT DISTINCT arn
    FROM aws_iam_policies p
    INNER JOIN aws_iam_policy_versions pv ON pv._cq_parent_id = p._cq_id
    , lateral flatten(input => pv.document_json:Statement) as s
    WHERE
        s.value:Effect = 'Allow'
        AND
        (s.value:Resource = '*' OR
        s.value:Resource LIKE '%kms%')
        AND 
        (s.value:Action = '*'
         OR s.value:Action ILIKE '%kms:*%'
         OR s.value:Action ILIKE '%kms:decrypt%'
         OR s.value:Action ILIKE '%kms:reencryptfrom%'
         OR s.value:Action ILIKE '%kms:reencrypt*%')
)
SELECT
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'IAM customer managed policies should not allow decryption actions on all KMS keys' AS title,
  i.account_id,
    i.arn AS resource_id,
    CASE 
        WHEN d.arn IS NULL THEN 'pass'
        ELSE 'fail'
    END AS status
FROM    
    aws_iam_policies i
LEFT JOIN policy_with_decrypt d ON i.arn = d.arn
{% endmacro %}

{% macro bigquery__iam_customer_policy_no_kms_decrypt(framework, check_id) %}
WITH policy_with_decrypt AS (
    SELECT DISTINCT arn
    FROM {{ full_table_name("aws_iam_policies") }} p
    INNER JOIN {{ full_table_name("aws_iam_policy_versions") }} pv 
    ON pv._cq_parent_id = p._cq_id, 
    UNNEST(JSON_QUERY_ARRAY(pv.document_json.Statement)) AS s
    WHERE
        JSON_VALUE(s.Effect) = 'Allow'
        AND
        (JSON_VALUE(s.Resource) = '*' OR
        JSON_VALUE(s.Resource) LIKE '%kms%')
        AND 
        (JSON_VALUE(s.Action) = '*'
         OR LOWER(JSON_VALUE(s.Action)) LIKE '%kms:*%'
         OR LOWER(JSON_VALUE(s.Action)) LIKE '%kms:decrypt%'
         OR LOWER(JSON_VALUE(s.Action)) LIKE '%kms:reencryptfrom%'
         OR LOWER(JSON_VALUE(s.Action)) LIKE '%kms:reencrypt*%')
)
SELECT
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'IAM customer managed policies should not allow decryption actions on all KMS keys' AS title,
  i.account_id,
    i.arn AS resource_id,
    CASE 
        WHEN d.arn IS NULL THEN 'pass'
        ELSE 'fail'
    END AS status
FROM    
    {{ full_table_name("aws_iam_policies") }} i
LEFT JOIN policy_with_decrypt d ON i.arn = d.arn
{% endmacro %}

{% macro athena__iam_customer_policy_no_kms_decrypt(framework, check_id) %}
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
          and 
          (resource = '*' or resource LIKE '%kms%')
          and ( action = '*' or action LIKE '%kms:*%' or action LIKE '%kms:decrypt%' or action LIKE '%kms:reencryptfrom%' or action LIKE '%kms:reencrypt*%')
    group by id
)
select distinct
    '{{framework}}' as framework,
    '{{check_id}}' as check_id,
      'IAM customer managed policies should not allow decryption actions on all KMS keys' AS title,
    account_id,
    arn AS resource_id,
    case when
        violations.id is not null AND violations.violations > 0
    then 'fail' else 'pass' end as status
from aws_iam_policies
left join violations on violations.id = aws_iam_policies.id
)
{% endmacro %}