#KMS.1
IAM_CUSTOMER_POLICY_NO_KMS_DECRYPT = """
INSERT INTO aws_policy_results
WITH policy_with_decrypt_grant AS (
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
  :1 as execution_time,
  :2 as framework,
  :3 as check_id,
  'IAM customer managed policies should not allow decryption actions on all KMS keys' AS title,
  i.account_id,
    i.arn AS resource_id,
    CASE 
        WHEN d.arn IS NULL THEN 'pass'
        ELSE 'fail'
    END AS status
FROM    
    aws_iam_policies i
LEFT JOIN policy_with_decrypt_grant d ON i.arn = d.arn;
"""

#KMS.2
IAM_INLINE_POLICY_NO_KMS_DECRYPT = """
INSERT INTO aws_policy_results
WITH decrypt_users as (
    SELECT DISTINCT
        u.user_arn as arn
    FROM 
        aws_iam_user_policies u,
        LATERAL FLATTEN(input => u.policy_document) inline_policy,
        LATERAL FLATTEN(input => inline_policy.value:"PolicyDocument":"Statement") s
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
  
),
decrypt_roles as (
  SELECT DISTINCT
        r.role_arn as arn
    FROM 
        aws_iam_role_policies r,
        LATERAL FLATTEN(input => r.policy_document) inline_policy,
        LATERAL FLATTEN(input => inline_policy.value:"PolicyDocument":"Statement") s
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
        AND r.role_arn NOT LIKE '%service-role/%'

),
decrypt_groups as (
  SELECT DISTINCT
        g.group_arn as arn
    FROM 
        aws_iam_group_policies g,
        LATERAL FLATTEN(input => g.policy_document) inline_policy,
        LATERAL FLATTEN(input => inline_policy.value:"PolicyDocument":"Statement") s
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
  :1 as execution_time,
  :2 as framework,
  :3 as check_id,
  'IAM principals should not have IAM inline policies that allow decryption actions on all KMS keys' AS title,
    u.account_id,
    u.arn as resource_id,
    CASE
    WHEN du.arn is not null THEN 'fail'
    ELSE 'pass'
    END as status
FROM aws_iam_users u
LEFT JOIN decrypt_users du
    ON u.arn = du.arn

UNION

SELECT
  :1 as execution_time,
  :2 as framework,
  :3 as check_id,
  'IAM principals should not have IAM inline policies that allow decryption actions on all KMS keys' AS title,
    r.account_id,
    r.arn as resource_id,
    CASE
    WHEN dr.arn is not null THEN 'fail'
    ELSE 'pass'
    END as status
FROM aws_iam_roles r
LEFT JOIN decrypt_roles dr
    ON r.arn = dr.arn

UNION

SELECT
  :1 as execution_time,
  :2 as framework,
  :3 as check_id,
  'IAM principals should not have IAM inline policies that allow decryption actions on all KMS keys' AS title,
    g.account_id,
    g.arn as resource_id,
    CASE
    WHEN dg.arn is not null THEN 'fail'
    ELSE 'pass'
    END as status
FROM aws_iam_groups g
LEFT JOIN decrypt_groups dg
    ON g.arn = dg.arn;
"""

#KMS.3
KEYS_NOT_UNINTENTIONALLY_DELETED = """
INSERT INTO aws_policy_results
SELECT 
  :1 as execution_time,
  :2 as framework,
  :3 as check_id,
  'AWS KMS keys should not be deleted unintentionally' AS title,
    account_id,
    arn AS resource_id,
    CASE 
        WHEN key_state = 'PendingDeletion' AND key_manager = 'CUSTOMER' THEN 'fail'
        ELSE 'pass'
    END AS status
FROM    
    aws_kms_keys;
"""

#KMS.4
KEY_ROTATION_ENABLED = """
INSERT INTO aws_policy_results
SELECT
  :1 as execution_time,
  :2 as framework,
  :3 as check_id,
  'AWS KMS key rotation should be enabled' AS title,
  account_id,
  arn AS resource_id,
  CASE
  WHEN (rotation_enabled = false or rotation_enabled is null) AND key_manager = 'CUSTOMER' THEN 'fail'
  ELSE 'pass'
  END as status
FROM
  aws_kms_keys;
"""