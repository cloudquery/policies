{% macro iam_users_are_managed_centrally(framework, check_id) %}
  {{ return(adapter.dispatch('iam_users_are_managed_centrally')(framework, check_id)) }}
{% endmacro %}

{% macro default__iam_users_are_managed_centrally(framework, check_id) %}{% endmacro %}

{% macro postgres__iam_users_are_managed_centrally(framework, check_id) %}
WITH identity_providers AS (
  SELECT
    account_id,
    COUNT(*) AS count
  FROM
    (
      SELECT
        account_id
      FROM
        aws_iam_openid_connect_identity_providers

      UNION

      SELECT
        account_id
      FROM
        aws_iam_saml_identity_providers
    ) providers
  GROUP BY
    account_id
)

SELECT
  '{{framework}}' AS framework,
  '{{check_id}}' AS check_id,
  'Ensure IAM users are managed centrally via identity federation or AWS Organizations for multi-account environments' AS title,
  a.account_id,
  a.account_id as resource_id,
  CASE
    WHEN COALESCE(ip.count, 0) = 0 THEN 'fail'
    ELSE 'pass'
  END AS status
FROM
  aws_iam_accounts a
LEFT JOIN
  identity_providers ip ON a.account_id = ip.account_id
GROUP BY
  a.account_id, ip.count
{% endmacro %}

{% macro snowflake__iam_users_are_managed_centrally(framework, check_id) %}
WITH identity_providers AS (
  SELECT
    account_id,
    COUNT(*) AS count
  FROM
    (
      SELECT
        account_id
      FROM
        aws_iam_openid_connect_identity_providers

      UNION

      SELECT
        account_id
      FROM
        aws_iam_saml_identity_providers
    ) providers
  GROUP BY
    account_id
)

SELECT
  '{{framework}}' AS framework,
  '{{check_id}}' AS check_id,
  'Ensure IAM users are managed centrally via identity federation or AWS Organizations for multi-account environments' AS title,
  a.account_id,
  a.account_id as resource_id,
  CASE
    WHEN COALESCE(ip.count, 0) = 0 THEN 'fail'
    ELSE 'pass'
  END AS status
FROM
  aws_iam_accounts a
LEFT JOIN
  identity_providers ip ON a.account_id = ip.account_id
GROUP BY
  a.account_id, ip.count
{% endmacro %}

{% macro bigquery__iam_users_are_managed_centrally(framework, check_id) %}
WITH identity_providers AS (
  SELECT
    account_id,
    COUNT(*) AS count
  FROM
    (
      SELECT
        account_id
      FROM
        {{ full_table_name("aws_iam_openid_connect_identity_providers") }}

      UNION ALL

      SELECT
        account_id
      FROM
        {{ full_table_name("aws_iam_saml_identity_providers") }}
    ) providers
  GROUP BY
    account_id
)

SELECT
  '{{framework}}' AS framework,
  '{{check_id}}' AS check_id,
  'Ensure IAM users are managed centrally via identity federation or AWS Organizations for multi-account environments' AS title,
  a.account_id,
  a.account_id as resource_id,
  CASE
    WHEN COALESCE(ip.count, 0) = 0 THEN 'fail'
    ELSE 'pass'
  END AS status
FROM
  {{ full_table_name("aws_iam_accounts") }} a
LEFT JOIN
  identity_providers ip ON a.account_id = ip.account_id
GROUP BY
  a.account_id, ip.count
{% endmacro %}

{% macro athena__iam_users_are_managed_centrally(framework, check_id) %}
  WITH identity_providers AS (
    SELECT
      account_id,
      COUNT(*) AS count
    FROM
      (
        SELECT
          account_id
        FROM
          aws_iam_openid_connect_identity_providers

        UNION

        SELECT
          account_id
        FROM
          aws_iam_saml_identity_providers
      ) providers
    GROUP BY
      account_id
  )

  SELECT
    '{{framework}}' AS framework,
    '{{check_id}}' AS check_id,
    'Ensure IAM users are managed centrally via identity federation or AWS Organizations for multi-account environments' AS title,
    a.account_id,
    a.account_id as resource_id,
    CASE
      WHEN COALESCE(ip.count, 0) = 0 THEN 'fail'
      ELSE 'pass'
    END AS status
  FROM
    aws_iam_accounts a
  LEFT JOIN
    identity_providers ip ON a.account_id = ip.account_id
  GROUP BY
    a.account_id, ip.count
{% endmacro %}