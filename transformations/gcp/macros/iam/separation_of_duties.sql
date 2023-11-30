{% macro iam_separation_of_duties(framework, check_id) %}
  {{ return(adapter.dispatch('iam_separation_of_duties')(framework, check_id)) }}
{% endmacro %}

{% macro default__iam_separation_of_duties(framework, check_id) %}{% endmacro %}

{% macro postgres__iam_separation_of_duties(framework, check_id) %}
with
    project_policy_roles as (
        select project_id, jsonb_array_elements(bindings) as binding
        from gcp_resourcemanager_project_policies
    ),
    role_members as (
        select
            project_id,
            binding ->> 'role' as "role",
            jsonb_array_elements_text(binding -> 'members') as member
        from project_policy_roles
    )
select
        member as resource_id,
        '{{framework}}' as framework,
        '{{check_id}}' as check_id,
        'Ensure that Separation of duties is enforced while assigning service account related roles to users (Automated)'
        as title,
        project_id as project_id,
        case
            when
                "role"
                in ('roles/iam.serviceAccountAdmin', 'roles/iam.serviceAccountUser')
                and "member" like 'user:%'
            then 'fail'
            else 'pass'
        end as status
    from role_members
{% endmacro %}

{% macro snowflake__iam_separation_of_duties(framework, check_id) %}
with
    project_policy_roles as (
        select project_id, binding.value as binding
        from gcp_resourcemanager_project_policies,
        LATERAL FLATTEN(input => bindings) AS binding
    ),
    role_members as (
        select
            project_id,
            binding:role as role,
            member.value as member
        from project_policy_roles,
        LATERAL FLATTEN(input => binding:members) AS member
    )
select
        member as resource_id,
        '{{framework}}' as framework,
        '{{check_id}}' as check_id,
        'Ensure that Separation of duties is enforced while assigning service account related roles to users (Automated)'
        as title,
        project_id as project_id,
        case
            when
                role
                in ('roles/iam.serviceAccountAdmin', 'roles/iam.serviceAccountUser')
                and member like ('user:%')
            then 'fail'
            else 'pass'
        end as status
    from role_members
{% endmacro %}

{% macro bigquery__iam_separation_of_duties(framework, check_id) %}
with
    project_policy_roles as (
        select project_id, JSON_EXTRACT_ARRAY(bindings) as binding_array
        from {{ full_table_name("gcp_resourcemanager_project_policies") }}
    ),
    role_members as (
        select
            project_id,
            binding,
            JSON_VALUE(binding, '$.role') as role,
            JSON_EXTRACT_STRING_ARRAY(binding, '$.members') as member
         from project_policy_roles,
          UNNEST(binding_array) AS binding
    )
select
        ARRAY_TO_STRING(member, ', ') resource_id,
        '{{framework}}' as framework,
        '{{check_id}}' as check_id,
        'Ensure that Separation of duties is enforced while assigning service account related roles to users (Automated)'
        as title,
        project_id as project_id,
        case
            when
                "role"
                in ('roles/iam.serviceAccountAdmin', 'roles/iam.serviceAccountUser')
                and "member" like 'user:%'
            then 'fail'
            else 'pass'
        end as status
    from role_members
{% endmacro %}