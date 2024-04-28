{% macro security_account_information_provided(framework, check_id) %}
  {{ return(adapter.dispatch('security_account_information_provided')(framework, check_id)) }}
{% endmacro %}

{% macro snowflake__security_account_information_provided(framework, check_id) %}
SELECT
'{{framework}}' As framework,
'{{check_id}}' As check_id,
'Security contact information should be provided for an AWS account' AS "title",
aws_iam_accounts.account_id as "account_id",
aws_iam_accounts.account_id as "resource_id",
CASE WHEN
'alternate_contact_type' IS NULL
THEN 'fail'
ELSE 'pass'
END AS "status"
FROM aws_iam_accounts
LEFT JOIN(
    SELECT * FROM aws_account_alternate_contacts
    WHERE 'alternate_contact_type'='SECURITY'
) AS account_security_contacts
ON 'aws_iam_accounts.account_id' = 'account_security_contacts.account_id'
{% endmacro %}

{% macro postgres__security_account_information_provided(framework, check_id) %}
select
  '{{framework}}' as framework,
  '{{check_id}}' as check_id,
  'Security contact information should be provided for an AWS account' as title,
  aws_iam_accounts.account_id,
  aws_iam_accounts.account_id as resource_id,
  case when
    alternate_contact_type is null
    then 'fail'
    else 'pass'
  end as status
FROM aws_iam_accounts
LEFT JOIN (
	SELECT * from aws_account_alternate_contacts
WHERE alternate_contact_type = 'SECURITY'
) as account_security_contacts
ON aws_iam_accounts.account_id = account_security_contacts.account_id{% endmacro %}

{% macro default__security_account_information_provided(framework, check_id) %}{% endmacro %}

{% macro bigquery__security_account_information_provided(framework, check_id) %}
SELECT
'{{framework}}' As framework,
'{{check_id}}' As check_id,
'Security contact information should be provided for an AWS account' AS title,
aws_iam_accounts.account_id as account_id,
aws_iam_accounts.account_id as resource_id,
CASE WHEN
'alternate_contact_type' IS NULL
THEN 'fail'
ELSE 'pass'
END AS status
FROM {{ full_table_name("aws_iam_accounts") }}

LEFT JOIN(
    SELECT * FROM {{ full_table_name("aws_account_alternate_contacts") }}

    WHERE alternate_contact_type='SECURITY'
) AS account_security_contacts
ON aws_iam_accounts.account_id = account_security_contacts.account_id
{% endmacro %}

{% macro athena__security_account_information_provided(framework, check_id) %}
SELECT
'{{framework}}' As framework,
'{{check_id}}' As check_id,
'Security contact information should be provided for an AWS account' AS "title",
aws_iam_accounts.account_id as "account_id",
aws_iam_accounts.account_id as "resource_id",
CASE WHEN
'alternate_contact_type' IS NULL
THEN 'fail'
ELSE 'pass'
END AS "status"
FROM aws_iam_accounts
LEFT JOIN(
    SELECT * FROM aws_account_alternate_contacts
    WHERE 'alternate_contact_type'='SECURITY'
) AS account_security_contacts
ON 'aws_iam_accounts.account_id' = 'account_security_contacts.account_id'
{% endmacro %}