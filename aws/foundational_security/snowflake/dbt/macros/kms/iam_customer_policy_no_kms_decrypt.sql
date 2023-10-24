{% macro iam_customer_policy_no_kms_decrypt(framework, check_id) %}
INSERT INTO aws_policy_results
WITH policy_with_decrypt AS (
    SELECT DISTINCT arn
    FROM aws_iam_policies p
    ,lateral flatten(input => p.POLICY_VERSION_LIST) as f
    ,lateral flatten(input => parse_json(f.value:Document):Statement) as s
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
LEFT JOIN policy_with_decrypt d ON i.arn = d.arn;
{% endmacro %}