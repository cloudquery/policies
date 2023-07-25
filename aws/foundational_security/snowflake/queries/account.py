


SECURITY_ACCOUNT_INFORMATION_PROVIDED = """
INSERT INTO aws_policy_results
SELECT
  :1 as execution_time,
  :2 as framework,
  :3 as check_id,
  'Security contact information should be provided for an AWS account' AS "title",
  aws_iam_accounts.account_id as "account_id",
  aws_iam_accounts.account_id as "resource_id",
  CASE WHEN
    'alternate_contact_type' IS NULL
    THEN 'fail'
    ELSE 'pass'
  END AS "status"
FROM aws_iam_accounts
LEFT JOIN (
  SELECT * FROM aws_account_alternate_contacts
  WHERE 'alternate_contact_type' = 'SECURITY'
) AS account_security_contacts
ON 'aws_iam_accounts.account_id' = 'account_security_contacts.account_id'
"""
