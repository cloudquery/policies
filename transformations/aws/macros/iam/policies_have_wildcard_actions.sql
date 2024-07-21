{% macro policies_have_wildcard_actions(framework, check_id) %}
  {{ return(adapter.dispatch('policies_have_wildcard_actions')(framework, check_id)) }}
{% endmacro %}

{% macro default__policies_have_wildcard_actions(framework, check_id) %}{% endmacro %}

{% macro postgres__policies_have_wildcard_actions(framework, check_id) %}
with bad_statements as (
SELECT
    p.account_id,
    p.arn as resource_id,
	a::text,
    CASE
        WHEN a::text ~ '^[a-zA-Z0-9]+:\\*$' 
            OR a::text = '*:*' THEN 1
        ELSE 0
    END as status

FROM
    aws_iam_policies p
INNER JOIN aws_iam_policy_default_versions pv ON pv._cq_parent_id = p._cq_id
			, JSONB_ARRAY_ELEMENTS(pv.document_json -> 'Statement') as s,
			JSONB_ARRAY_ELEMENTS_TEXT(s -> 'Action') as a
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
        WHEN a.value::string REGEXP '^[a-zA-Z0-9]+:\\*$' 
            OR a.value::string = '*:*' THEN 1
        ELSE 0
    END as status

FROM
    aws_iam_policies p
    INNER JOIN aws_iam_policy_default_versions pv ON pv._cq_parent_id = p._cq_id
    , lateral flatten(input => pv.document_json:Statement) as s,
    lateral flatten(input => s.value:Action) as a
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

{% macro bigquery__policies_have_wildcard_actions(framework, check_id) %}
with bad_statements as (
SELECT
    p.account_id,
    p.arn as resource_id,
    CASE
        WHEN REGEXP_CONTAINS(JSON_VALUE(action), r'^[a-zA-Z0-9]+:\*$')
            OR JSON_VALUE(action) = '*:*' THEN 1
        ELSE 0
    END as status

FROM
    {{ full_table_name("aws_iam_policies") }} p
    INNER JOIN {{ full_table_name("aws_iam_policy_default_versions") }} pv
     ON pv._cq_parent_id = p._cq_id, 
    UNNEST(JSON_QUERY_ARRAY(pv.document_json.Statement)) AS s,
    UNNEST(JSON_QUERY_ARRAY(s.Action)) AS action
where pv.is_default_version = true AND JSON_VALUE(s.Effect) = 'Allow'
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

{% macro athena__policies_have_wildcard_actions(framework, check_id) %}
select * from (
WITH iam_policies AS (
    SELECT
        p.id AS id,
        p.account_id,
        p.arn,
        CASE 
    WHEN json_array_length(json_extract(pv.document_json, '$.Statement')) IS NULL THEN
      json_parse('[' || json_extract_scalar(pv.document_json, '$.Statement') || ']')
    ELSE
      json_extract(pv.document_json, '$.Statement')
  END AS statement
    FROM aws_iam_policies p
    JOIN aws_iam_policy_default_versions pv ON pv._cq_parent_id = p._cq_id
    WHERE pv.is_default_version = TRUE and p.arn not like 'arn:aws:iam::aws:policy%'
),
policy_statements AS (
    SELECT
        id,
        account_id,
        arn,
        t.statement,
      CASE 
        WHEN json_array_length(json_extract(t.statement, '$.Action')) IS NULL THEN
          json_parse('["' || json_extract_scalar(t.statement, '$.Action') || '"]')
        ELSE
          json_extract(t.statement, '$.Action')
      END AS action_fixed
    FROM iam_policies
    CROSS JOIN UNNEST(CAST(statement AS array(json))) AS t(statement)
),
bad_statements AS (
    SELECT
        ps.account_id,
        ps.arn AS resource_id,
        CASE
            WHEN action LIKE '%:*'
                OR action = '*' THEN 1
            ELSE 0
        END AS status
    FROM
        policy_statements ps,
        UNNEST(CAST(action_fixed as array(varchar))) t(action)
    WHERE JSON_EXTRACT_SCALAR(ps.statement, '$.Effect') = 'Allow'
)
SELECT DISTINCT
    '{{framework}}' AS framework,
    '{{check_id}}' AS check_id,
    'IAM customer managed policies that you create should not allow wildcard actions for services' AS title,
    account_id,
    resource_id,
    CASE
        WHEN MAX(status) OVER(PARTITION BY resource_id) = 1 THEN 'fail'
        ELSE 'pass'
    END AS status
FROM
    bad_statements
)
{% endmacro %}
