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
INNER JOIN aws_iam_policy_versions pv ON pv._cq_parent_id = p._cq_id
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
    INNER JOIN aws_iam_policy_versions pv ON pv._cq_parent_id = p._cq_id
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

{% macro bigquery__policies_have_wildcard_actions(framework, check_id) %}
with bad_statements as (
SELECT
    p.account_id,
    p.arn as resource_id,
    CASE
        WHEN REGEXP_CONTAINS(JSON_VALUE(s.Action), r'^[a-zA-Z0-9]+:\*$')
            OR JSON_VALUE(s.Action) = '*:*' THEN 1
        ELSE 0
    END as status

FROM
    {{ full_table_name("aws_iam_policies") }} p
    INNER JOIN {{ full_table_name("aws_iam_policy_versions") }} pv
     ON pv._cq_parent_id = p._cq_id, 
    UNNEST(JSON_QUERY_ARRAY(pv.document_json.Statement)) AS s
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
    JOIN aws_iam_policy_versions pv ON pv._cq_parent_id = p._cq_id
    WHERE pv.is_default_version = TRUE and p.arn not like 'arn:aws:iam::aws:policy%'
),
policy_statements AS (
    SELECT
        id,
        account_id,
        arn,
        t.statement
    FROM iam_policies
    CROSS JOIN UNNEST(CAST(statement AS array(json))) AS t(statement)
),
bad_statements AS (
    SELECT
        ps.account_id,
        ps.arn AS resource_id,
        CASE
            WHEN JSON_EXTRACT_SCALAR(ps.statement, '$.Action') LIKE '%:*'
                OR JSON_EXTRACT_SCALAR(ps.statement, '$.Action') = '*' THEN 1
            ELSE 0
        END AS status
    FROM
        policy_statements ps
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
