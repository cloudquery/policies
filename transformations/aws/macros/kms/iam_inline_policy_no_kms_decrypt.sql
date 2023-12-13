{% macro iam_inline_policy_no_kms_decrypt(framework, check_id) %}
  {{ return(adapter.dispatch('iam_inline_policy_no_kms_decrypt')(framework, check_id)) }}
{% endmacro %}

{% macro default__iam_inline_policy_no_kms_decrypt(framework, check_id) %}{% endmacro %}

{% macro postgres__iam_inline_policy_no_kms_decrypt(framework, check_id) %}
WITH decrypt_users as (
    SELECT DISTINCT
        u.user_arn as arn
    FROM 
        aws_iam_user_policies u,
		JSONB_ARRAY_ELEMENTS(u.policy_document) AS inline_policy,
		JSONB_ARRAY_ELEMENTS(inline_policy -> 'PolicyDocument' -> 'Statement') AS s
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
  
),
decrypt_roles as (
  SELECT DISTINCT
        r.role_arn as arn
    FROM 
        aws_iam_role_policies r,
		JSONB_ARRAY_ELEMENTS(r.policy_document) AS inline_policy,
		JSONB_ARRAY_ELEMENTS(inline_policy -> 'PolicyDocument' -> 'Statement') AS s
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
        AND r.role_arn NOT LIKE '%service-role/%'

),
decrypt_groups as (
  SELECT DISTINCT
        g.group_arn as arn
    FROM 
        aws_iam_group_policies g,
        JSONB_ARRAY_ELEMENTS(g.policy_document) AS inline_policy,
		JSONB_ARRAY_ELEMENTS(inline_policy -> 'PolicyDocument' -> 'Statement') AS s
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
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
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
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'IAM principals should not have IAM inline policies that allow decryption actions on all KMS keys' AS title,
    g.account_id,
    g.arn as resource_id,
    CASE
    WHEN dg.arn is not null THEN 'fail'
    ELSE 'pass'
    END as status
FROM aws_iam_groups g
LEFT JOIN decrypt_groups dg
    ON g.arn = dg.arn
{% endmacro %}

{% macro snowflake__iam_inline_policy_no_kms_decrypt(framework, check_id) %}
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
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
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
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
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
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'IAM principals should not have IAM inline policies that allow decryption actions on all KMS keys' AS title,
    g.account_id,
    g.arn as resource_id,
    CASE
    WHEN dg.arn is not null THEN 'fail'
    ELSE 'pass'
    END as status
FROM aws_iam_groups g
LEFT JOIN decrypt_groups dg
    ON g.arn = dg.arn
{% endmacro %}