{% macro iam_customer_policy_no_kms_decrypt(framework, check_id) %}
wITH policy_with_decrypt AS (
    SELECT DISTINCT arn
    FROM aws_iam_policies p
    INNER JOIN aws_iam_policy_versions pv ON p.account_id = pv.account_id AND p.arn = pv.policy_arn
    , lateral flatten(input => pv.document_json -> 'Statement') as s
    WHERE
        s ->> 'Effect' = 'Allow'
        AND
        (s ->> 'Resource' = '*' OR
        s ->> 'Resource' LIKE '%kms%')
        AND 
        (s ->> 'Action' = '*'
         OR s ->> 'Action' ILIKE '%kms:*%'
         OR s ->> 'Action' ILIKE '%kms:decrypt%'
         OR s ->> 'Action' ILIKE '%kms:reencryptfrom%'
         OR s ->> 'Action' ILIKE '%kms:reencrypt*%')
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