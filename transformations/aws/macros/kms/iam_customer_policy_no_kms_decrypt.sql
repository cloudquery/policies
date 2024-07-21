{% macro iam_customer_policy_no_kms_decrypt(framework, check_id) %}
  {{ return(adapter.dispatch('iam_customer_policy_no_kms_decrypt')(framework, check_id)) }}
{% endmacro %}

{% macro default__iam_customer_policy_no_kms_decrypt(framework, check_id) %}{% endmacro %}

{% macro postgres__iam_customer_policy_no_kms_decrypt(framework, check_id) %}
with pvs as (
    select
        p.id,
        pv.document_json as document
    from aws_iam_policies p
    inner join aws_iam_policy_default_versions pv on pv._cq_parent_id = p._cq_id
), violations as (
    select
        id,
        COUNT(*) as violations
    from pvs,
        JSONB_ARRAY_ELEMENTS(
            case JSONB_TYPEOF(document -> 'Statement')
                when 'string' then JSONB_BUILD_ARRAY(document ->> 'Statement')
                when 'array' then document -> 'Statement'
            end
        ) as statement,
        JSONB_ARRAY_ELEMENTS_TEXT(
            case JSONB_TYPEOF(statement -> 'Resource')
                when 'string' then JSONB_BUILD_ARRAY(statement ->> 'Resource')
                when 'array' then statement -> 'Resource' end
        ) as resource,
        JSONB_ARRAY_ELEMENTS_TEXT( case JSONB_TYPEOF(statement -> 'Action')
                when 'string' then JSONB_BUILD_ARRAY(statement ->> 'Action')
                when 'array' then statement -> 'Action' end
        ) as action
    where statement ->> 'Effect' = 'Allow'
          and (resource = '*' or resource like '%kms%')
          and ( action = '*' or action = 'kms:Decrypt' or action = 'kms:ReEncryptFrom')
    group by id
)
select distinct
    '{{framework}}' as framework,
    '{{check_id}}' as check_id,
    'IAM customer managed policies should not allow decryption actions on all KMS keys' AS title,
    account_id,
    arn AS resource_id,
    case when
        violations.id is not null AND violations.violations > 0
    then 'fail' else 'pass' end as status
from aws_iam_policies
left join violations on violations.id = aws_iam_policies.id
{% endmacro %}

{% macro snowflake__iam_customer_policy_no_kms_decrypt(framework, check_id) %}
with pvs as (
    select
        p.id,
        pv.document_json as document
    from aws_iam_policies p
    inner join aws_iam_policy_default_versions pv on pv._cq_parent_id = p._cq_id
), violations as (
    select
        id,
        COUNT(*) as violations
    from pvs,
        LATERAL FLATTEN(document:Statement) as statement,
        LATERAL FLATTEN(statement.value:Resource) as resource,
        LATERAL FLATTEN(statement.value:Action) as action,
    where statement.value:Effect = 'Allow'
          and (resource.value = '*' or resource.value like '%kms%')
          and ( action.value = '*' or action.value = 'kms:Decrypt' or action.value = 'kms:ReEncryptFrom')
    group by id
)

select distinct
    '{{framework}}' as framework,
    '{{check_id}}' as check_id,
    'IAM customer managed policies should not allow decryption actions on all KMS keys' AS title,
    account_id,
    arn AS resource_id,
    case when
        violations.id is not null AND violations.violations > 0
    then 'fail' else 'pass' end as status
from aws_iam_policies
left join violations on violations.id = aws_iam_policies.id
{% endmacro %}

{% macro bigquery__iam_customer_policy_no_kms_decrypt(framework, check_id) %}
with pvs as (
    select
        p.id,
        pv.document_json as document
    from {{ full_table_name("aws_iam_policies") }} p
    inner join {{ full_table_name("aws_iam_policy_default_versions") }} pv on pv._cq_parent_id = p._cq_id
), violations as (
    select
        id,
        COUNT(*) as violations
    from pvs,
    UNNEST(JSON_QUERY_ARRAY(document.Statement)) AS statement,
    UNNEST(JSON_QUERY_ARRAY(statement.Resource)) AS resource,
    UNNEST(JSON_QUERY_ARRAY(statement.Action)) AS action
    where JSON_VALUE(statement.Effect) = 'Allow'
          and (JSON_VALUE(resource) = '*' or JSON_VALUE(resource) like '%kms%')
          and ( JSON_VALUE(action) = '*' or JSON_VALUE(action) = 'kms:Decrypt' or JSON_VALUE(action) = 'kms:ReEncryptFrom')
    group by id
)
select distinct
    '{{framework}}' as framework,
    '{{check_id}}' as check_id,
    CONCAT('IAM policies should not allow full ', '''*''', ' administrative privileges') AS title,
    account_id,
    arn AS resource_id,
    case when
        violations.id is not null AND violations.violations > 0
    then 'fail' else 'pass' end as status
from {{ full_table_name("aws_iam_policies") }}
left join violations on violations.id = aws_iam_policies.id
{% endmacro %}

{% macro athena__iam_customer_policy_no_kms_decrypt(framework, check_id) %}
select * from (
WITH pvs AS (
    SELECT
        p.id AS id,
        CASE 
    WHEN json_array_length(json_extract(pv.document_json, '$.Statement')) IS NULL THEN
      json_parse('[' || json_extract_scalar(pv.document_json, '$.Statement') || ']')
    ELSE
      json_extract(pv.document_json, '$.Statement')
  END AS statement_fixed
    FROM aws_iam_policies p
    JOIN aws_iam_policy_default_versions pv ON pv._cq_parent_id = p._cq_id
),
fix_resouce_action as (
    SELECT
      id,
      statement as statement_fixed,
      CASE 
        WHEN json_array_length(json_extract(statement, '$.Resource')) IS NULL THEN
          json_parse('["' || json_extract_scalar(statement, '$.Resource') || '"]')
        ELSE
          json_extract(statement, '$.Resource')
      END AS resource_fixed,
      CASE 
        WHEN json_array_length(json_extract(statement, '$.Action')) IS NULL THEN
          json_parse('["' || json_extract_scalar(statement, '$.Action') || '"]')
        ELSE
          json_extract(statement, '$.Action')
      END AS action_fixed
    FROM pvs,
    UNNEST(CAST(statement_fixed as array(json))) as t(statement)
),
violations as (
    select
        id,
        COUNT(*) as violations
    from fix_resouce_action,
        UNNEST(CAST(resource_fixed as array(varchar))) t(resource),
        UNNEST(CAST(action_fixed as array(varchar))) t(action)
    where JSON_EXTRACT_SCALAR(statement_fixed, '$.Effect') = 'Allow'
          and 
          (resource = '*' or resource LIKE '%kms%')
          and ( action = '*' or action LIKE '%kms:*%' or action LIKE '%kms:decrypt%' or action LIKE '%kms:reencryptfrom%' or action LIKE '%kms:reencrypt*%')
    group by id
)
select distinct
    '{{framework}}' as framework,
    '{{check_id}}' as check_id,
      'IAM customer managed policies should not allow decryption actions on all KMS keys' AS title,
    account_id,
    arn AS resource_id,
    case when
        violations.id is not null AND violations.violations > 0
    then 'fail' else 'pass' end as status
from aws_iam_policies
left join violations on violations.id = aws_iam_policies.id
)
{% endmacro %}