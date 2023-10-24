{% macro policies_have_wildcard_actions(framework, check_id) %}
INSERT INTO aws_policy_results
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
    , lateral flatten(input => p.POLICY_VERSION_LIST) as f
    , lateral flatten(input => parse_json(f.value:Document):Statement) as s
where f.value:IsDefaultVersion = 'true' AND s.value:Effect = 'Allow'
  
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