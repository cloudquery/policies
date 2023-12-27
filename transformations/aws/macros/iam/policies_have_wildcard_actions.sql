{% macro policies_have_wildcard_actions(framework, check_id) %}
  {{ return(adapter.dispatch('policies_have_wildcard_actions')(framework, check_id)) }}
{% endmacro %}

{% macro default__policies_have_wildcard_actions(framework, check_id) %}{% endmacro %}

{% macro postgres__policies_have_wildcard_actions(framework, check_id) %}
with bad_statements as (
SELECT
    p.account_id,
    p.arn as resource_id,
    CASE
        WHEN s ->> 'Action' ~ '^[a-zA-Z0-9]+:\*$' 
            OR s ->> 'Action' = '*:*' THEN 1
        ELSE 0
    END as status

FROM
    aws_iam_policies p
INNER JOIN aws_iam_policy_versions pv ON p.account_id = pv.account_id AND p.arn = pv.policy_arn
			, JSONB_ARRAY_ELEMENTS(pv.document_json -> 'Statement') as s
where pv.is_default_version = true AND s ->> 'Effect' = 'Allow'

  )
select DISTINCT
      '{{framework}}' As framework,
      '{{check_id}}' As check_id,
      'IAM customer managed policies that you create should not allow wildcard actions for services' AS title,
       account_id,
       resource_id,
       CASE
           WHEN max(status) over(partition by resource_id) = 1 THEN 'fail'
           ELSE 'pass'
       END as status
FROM
    bad_statements
{% endmacro %}

{% macro snowflake__policies_have_wildcard_actions(framework, check_id) %}
with bad_statements as (
SELECT
    p.account_id,
    p.arn as resource_id,
    CASE
        WHEN s.value:Action REGEXP '^[a-zA-Z0-9]+:\*$' 
            OR s.value:Action = '*:*' THEN 1
        ELSE 0
    END as status

FROM
    aws_iam_policies p
    INNER JOIN aws_iam_policy_versions pv ON p.account_id = pv.account_id AND p.arn = pv.policy_arn
    , lateral flatten(input => pv.document_json:Statement) as s
where pv.is_default_version = true AND s.value:Effect = 'Allow'
)
select DISTINCT
      '{{framework}}' As framework,
      '{{check_id}}' As check_id,
      'IAM customer managed policies that you create should not allow wildcard actions for services' AS title,
       account_id,
       resource_id,
       CASE
           WHEN max(status) over(partition by resource_id) = 1 THEN 'fail'
           ELSE 'pass'
       END as status
FROM
    bad_statements
{% endmacro %}