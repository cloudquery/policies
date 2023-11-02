{% macro security_account_information_provided(framework, check_id) %}
    {{
        return(
            adapter.dispatch("security_account_information_provided")(
                framework, check_id
            )
        )
    }}
{% endmacro %}

{% macro snowflake__security_account_information_provided(framework, check_id) %}
    select
        '{{framework}}' as framework,
        '{{check_id}}' as check_id,
        'Security contact information should be provided for an AWS account' as "title",
        aws_iam_accounts.account_id as "account_id",
        aws_iam_accounts.account_id as "resource_id",
        case
            when 'alternate_contact_type' is null then 'fail' else 'pass'
        end as "status"
    from aws_iam_accounts
    left join
        (
            select *
            from aws_account_alternate_contacts
            where 'alternate_contact_type' = 'SECURITY'
        ) as account_security_contacts
        on 'aws_iam_accounts.account_id' = 'account_security_contacts.account_id'
{% endmacro %}

{% macro postgres__security_account_information_provided(framework, check_id) %}
    select
        '{{framework}}' as framework,
        '{{check_id}}' as check_id,
        'Security contact information should be provided for an AWS account' as title,
        {{ ref('view_aws_iam_accounts') }}.account_id,
        case when alternate_contact_type is null then 'fail' else 'pass' end as status
    from {{ ref('view_aws_iam_accounts') }} 
    left join
        (
            select *
            from {{ ref('view_aws_account_alternate_contacts') }}
            where alternate_contact_type = 'SECURITY'
        ) as account_security_contacts
        on {{ ref('view_aws_iam_accounts') }}.account_id = account_security_contacts.account_id
{% endmacro %}
