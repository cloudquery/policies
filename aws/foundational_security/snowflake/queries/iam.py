POLICIES_WITH_ADMIN_RIGHTS = """
insert into aws_policy_results
with bad_statements as (
SELECT
    p.id
FROM
    aws_iam_policies p
    , lateral flatten(input => p.POLICY_VERSION_LIST) as f
    , lateral flatten(input => parse_json(f.value:Document):Statement) as s
where f.value:IsDefaultVersion = 'true'
    and s.value:Effect = 'Allow'
            and (s.value:Action = '*' or s.value:Action = '*:*')
            and s.value:Resource = '*' 
)
select
    :1 as execution_time,
    :2 as framework,
    :3 as check_id,
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
WHERE p.arn REGEXP '.*\\d{12}.*';
"""

POLICIES_ATTACHED_TO_GROUPS_ROLES = """
insert into aws_policy_results
select distinct
    :1 as execution_time,
    :2 as framework,
    :3 as check_id,
    'IAM users should not have IAM policies attached' as title,
    aws_iam_users.account_id,
    arn AS resource_id,
    case when
        aws_iam_user_attached_policies.user_arn is not null
    then 'fail' else 'pass' end as status
from aws_iam_users
left join aws_iam_user_attached_policies on aws_iam_users.arn = aws_iam_user_attached_policies.user_arn
"""

IAM_ACCESS_KEYS_ROTATED_MORE_THAN_90_DAYS = """
INSERT INTO aws_policy_results
SELECT
    :1 as execution_time,
    :2 as framework,
    :3 as check_id,
    'IAM users access keys should be rotated every 90 days or less' AS title,
    account_id,
    access_key_id AS resource_id,
    CASE 
        WHEN DATEDIFF('DAY', last_rotated, CURRENT_TIMESTAMP()) > 90 THEN 'fail'
        ELSE 'pass'
    END AS status
FROM aws_iam_user_access_keys;
"""

ROOT_USER_NO_ACCESS_KEYS = """
insert into aws_policy_results
select
  :1 as execution_time,
  :2 as framework,
  :3 as check_id,
  'Ensure no root account access key exists (Scored)' as title,
  account_id,
  user_arn AS resource_id,
  case when
    user_name IN ('<root>', '<root_account>')
    then 'fail'
    else 'pass'
  end
from aws_iam_user_access_keys;
"""

MFA_ENABLED_FOR_CONSOLE_ACCESS = """
insert into aws_policy_results
select
  :1 as execution_time,
  :2 as framework,
  :3 as check_id,
  'Ensure MFA is enabled for all IAM users that have a console password (Scored)' as title,
  split_part(arn, ':', 5) as account_id,
  arn as resource_id,
  case when
    password_status IN ('TRUE', 'true') and not mfa_active
    then 'fail'
    else 'pass'
  end as status
from aws_iam_credential_reports
"""

HARDWARE_MFA_ENABLED_FOR_ROOT = """
insert into aws_policy_results
select
  :1 as execution_time,
  :2 as framework,
  :3 as check_id,
  'Ensure hardware MFA is enabled for the "root" account (Scored)' as title,
  split_part(cr.arn, ':', 5) as account_id,
  cr.arn as resource_id,
  case
    when mfa.serial_number is null or cr.mfa_active = FALSE then 'fail'
    when mfa.serial_number is not null and cr.mfa_active = TRUE then 'pass'
  end as status
from aws_iam_credential_reports cr
left join
    aws_iam_virtual_mfa_devices mfa on
        mfa.user:Arn = cr.arn
where cr.user = '<root_account>'
group by mfa.serial_number, cr.mfa_active, cr.arn;
"""

PASSWORD_POLICY_STRONG = """
INSERT INTO aws_policy_results
SELECT
  :1 AS execution_time,
  :2 AS framework,
  :3 AS check_id,
  'Password policies for IAM users should have strong configurations' AS title,
  account_id,
  account_id AS resource_id,
  CASE 
    WHEN (
        require_uppercase_characters != TRUE
        OR require_lowercase_characters != TRUE
        OR require_numbers != TRUE
        OR minimum_password_length < 14
        OR password_reuse_prevention IS NULL
        OR max_password_age IS NULL
        OR policy_exists != TRUE
    )
    THEN 'fail' 
    ELSE 'pass' 
  END AS status
FROM aws_iam_password_policies;
"""

IAM_ACCESS_KEYS_UNUSED_MORE_THAN_90_DAYS = """
INSERT INTO aws_policy_results
SELECT
    :1 as execution_time,
    :2 as framework,
    :3 as check_id,
    'Unused IAM user credentials should be removed' AS title,
    account_id,
    access_key_id AS resource_id,
    CASE 
        WHEN DATEDIFF('DAY', last_used, CURRENT_TIMESTAMP()) > 90 THEN 'fail'
        ELSE 'pass'
    END AS status
FROM aws_iam_user_access_keys;
"""

POLICIES_HAVE_WILDCARD_ACTIONS = """
INSERT INTO aws_policy_results
with bad_statements as (
SELECT
    p.account_id,
    p.arn as resource_id,
    CASE
        WHEN s.value:Action REGEXP '^[a-zA-Z0-9]+:\\*$' 
            OR s.value:Action = '*:*' THEN 1
        ELSE 0
    END as status

FROM
    aws_iam_policies p
    , lateral flatten(input => p.POLICY_VERSION_LIST) as f
    , lateral flatten(input => parse_json(f.value:Document):Statement) as s
where f.value:IsDefaultVersion = 'true' AND s.value:Effect = 'Allow'
  
  )
select DISTINCT
      :1 as execution_time,
      :2 as framework,
      :3 as check_id,
      'IAM customer managed policies that you create should not allow wildcard actions for services' AS title,
       account_id,
       resource_id,
       CASE
           WHEN max(status) over(partition by resource_id) = 1 THEN 'fail'
           ELSE 'pass'
       END as status
FROM
    bad_statements
"""