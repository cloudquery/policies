{% macro iam_users_with_service_account_token_creator_role(framework, check_id) %}
  {{ return(adapter.dispatch('iam_users_with_service_account_token_creator_role')(framework, check_id)) }}
{% endmacro %}

{% macro default__iam_users_with_service_account_token_creator_role(framework, check_id) %}{% endmacro %}

{% macro postgres__iam_users_with_service_account_token_creator_role(framework, check_id) %}
with
    project_policy_roles as (
        select _cq_sync_time, project_id, jsonb_array_elements(bindings) as binding
        from gcp_resourcemanager_project_policies
    ),
    role_members as (
        select
            _cq_sync_time,
            project_id,
            binding ->> 'role' as "role",
            jsonb_array_elements_text(binding -> 'members') as member
        from project_policy_roles
    )
select
        member as resource_id,
        _cq_sync_time as sync_time,
        '{{framework}}' as framework,
        '{{check_id}}' as check_id,
        'Ensure that IAM users are not assigned the Service Account User or Service Account Token Creator roles at project level (Automated)'
        as title,
        project_id as project_id,
        case
            when
                "role" in (
                    'roles/iam.serviceAccountUser',
                    'roles/iam.serviceAccountTokenCreator'
                )
                and "member" like 'user:%'
            then 'fail'
            else 'pass'
        end as status
    from role_members
{% endmacro %}

{% macro snowflake__iam_users_with_service_account_token_creator_role(framework, check_id) %}
with
    project_policy_roles as (
        select _cq_sync_time, project_id,
        binding.value as binding
        from gcp_resourcemanager_project_policies,
        LATERAL FLATTEN(input => bindings) AS binding
    ),
    role_members as (
        select
            _cq_sync_time,
            project_id,
            binding:role as role,
            member.value as member
        from project_policy_roles,
        LATERAL FLATTEN(input => binding:members) AS member
    )
select
        member as resource_id,
        _cq_sync_time as sync_time,
        '{{framework}}' as framework,
        '{{check_id}}' as check_id,
        'Ensure that IAM users are not assigned the Service Account User or Service Account Token Creator roles at project level (Automated)'
        as title,
        project_id as project_id,
        case
            when
                role in (
                    'roles/iam.serviceAccountUser',
                    'roles/iam.serviceAccountTokenCreator'
                )
                and member like ('user:%')
            then 'fail'
            else 'pass'
        end as status
    from role_members
{% endmacro %}
