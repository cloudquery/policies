{% macro iam_customer_policy_no_kms_decrypt(framework, check_id) %}
wITH policy_with_decrypt AS (
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