{% macro wildcard_access_policies(framework, check_id) %}
  {{ return(adapter.dispatch('wildcard_access_policies')(framework, check_id)) }}
{% endmacro %}

{% macro default__wildcard_access_policies(framework, check_id) %}{% endmacro %}

{% macro postgres__wildcard_access_policies(framework, check_id) %}
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
        JSONB_ARRAY_ELEMENTS_TEXT( case JSONB_TYPEOF(statement -> 'Action')
                when 'string' then JSONB_BUILD_ARRAY(statement ->> 'Action')
                when 'array' then statement -> 'Action' end
        ) as action
LEFT JOIN LATERAL (
	SELECT JSONB_ARRAY_ELEMENTS_TEXT(
		CASE JSONB_TYPEOF(statement -> 'NotAction')
			WHEN 'string' THEN JSONB_BUILD_ARRAY(statement ->> 'NotAction')
			WHEN 'array' THEN statement -> 'NotAction'
		END
	) AS not_action
) AS not_action_query ON TRUE
where statement ->> 'Effect' = 'Allow'
          and action like '%:*'
          or not_action like '%:*'
    group by id
)

select distinct
    '{{framework}}' as framework,
    '{{check_id}}' as check_id,
    'IAM customer managed policies that you create should not allow wildcard actions for services' as title,
    account_id,
    arn AS resource_id,
    case when
        violations.id is not null AND violations.violations > 0
    then 'fail' else 'pass' end as status
from aws_iam_policies
left join violations on violations.id = aws_iam_policies.id
{% endmacro %}
