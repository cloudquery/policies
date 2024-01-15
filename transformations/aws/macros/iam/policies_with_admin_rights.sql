{% macro policies_with_admin_rights(framework, check_id) %}
  {{ return(adapter.dispatch('policies_with_admin_rights')(framework, check_id)) }}
{% endmacro %}

{% macro snowflake__policies_with_admin_rights(framework, check_id) %}
with bad_statements as (
SELECT
    p.id
FROM
    aws_iam_policies p
    INNER JOIN aws_iam_policy_versions pv ON pv._cq_parent_id = p._cq_id
    , lateral flatten(input => pv.document_json:Statement) as s
where pv.is_default_version = 'true' AND s.value:Effect = 'Allow'
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

{% macro postgres__policies_with_admin_rights(framework, check_id) %}
with iam_policies as (
    select
        p.id as id,
        pv.document_json as document
    from aws_iam_policies p
    inner join aws_iam_policy_versions pv ON pv._cq_parent_id = p._cq_id
    where pv.is_default_version = true and p.arn not like 'arn:aws:iam::aws:policy%'
),
policy_statements as (
    select
        id,
        JSONB_ARRAY_ELEMENTS(
            case JSONB_TYPEOF(document -> 'Statement')
                when 'string' then JSONB_BUILD_ARRAY(document ->> 'Statement')
                when 'array' then document -> 'Statement' end
        ) as statement
    from
        iam_policies
),
allow_all_statements as (
    select
        id,
        COUNT(statement) as statements_count
    from policy_statements
    where (statement ->> 'Action' = '*'
        or statement ->> 'Action' like '%"*"%')
        and statement ->> 'Effect' = 'Allow'
        and (statement ->> 'Resource' = '*'
            or statement ->> 'Resource' like '%"*"%')
    group by id
)

select distinct
    '{{framework}}' as framework,
    '{{check_id}}' as check_id,
    'IAM policies should not allow full ''*'' administrative privileges' as title,
    aws_iam_policies.account_id,
    aws_iam_policies.arn AS resource_id,
    CASE WHEN statements_count > 0 THEN 'fail' ELSE 'pass' END AS status
from aws_iam_policies
left join
    allow_all_statements on aws_iam_policies.id = allow_all_statements.id
{% endmacro %}

{% macro default__policies_with_admin_rights(framework, check_id) %}{% endmacro %}

{% macro bigquery__policies_with_admin_rights(framework, check_id) %}
with bad_statements as (
SELECT
    p.id
FROM
    {{ full_table_name("aws_iam_policies") }} p
    INNER JOIN {{ full_table_name("aws_iam_policy_versions") }} pv 
    ON pv._cq_parent_id = p._cq_id, 
    UNNEST(JSON_QUERY_ARRAY(pv.document_json.Statement)) AS s
where pv.is_default_version = true AND JSON_VALUE(s.Effect) = 'Allow'
    and JSON_VALUE(s.Effect) = 'Allow'
            and (JSON_VALUE(s.Action) = '*' or JSON_VALUE(s.Action) = '*:*')
            and JSON_VALUE(s.Resource) = '*'
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
    {{ full_table_name("aws_iam_policies") }} as p
LEFT JOIN bad_statements as b
    ON p.id = b.id
WHERE REGEXP_CONTAINS(p.arn, r'.*\d{12}.*')
{% endmacro %}