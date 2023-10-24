{% macro policies_with_admin_rights(framework, check_id) %}
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
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
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
WHERE p.arn REGEXP '.*\d{12}.*'
{% endmacro %}