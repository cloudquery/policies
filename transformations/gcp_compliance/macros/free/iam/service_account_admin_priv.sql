{% macro iam_service_account_admin_priv(framework, check_id) %}
  {{ return(adapter.dispatch('iam_service_account_admin_priv')(framework, check_id)) }}
{% endmacro %}

{% macro default__iam_service_account_admin_priv(framework, check_id) %}{% endmacro %}

{% macro postgres__iam_service_account_admin_priv(framework, check_id) %}
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
        'Ensure that Service Account has no Admin privileges (Automated)' as title,
        project_id as project_id,
        case
            when
                (
                    "role" in ('roles/editor', 'roles/owner')
                    or "role" like any (array['%Admin', '%admin'])
                )
                and "member" like 'serviceAccount:%.iam.gserviceaccount.com'
            then 'fail'
            else 'pass'
        end as status
    from role_members
{% endmacro %}

{% macro snowflake__iam_service_account_admin_priv(framework, check_id) %}
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
        'Ensure that Service Account has no Admin privileges (Automated)' as title,
        project_id as project_id,
        case
            when
                (
                    role in ('roles/editor', 'roles/owner')
                    or role LIKE ANY ('%Admin', '%admin')
                )
                and member like 'serviceAccount:%.iam.gserviceaccount.com'
            then 'fail'
            else 'pass'
        end as status
    from role_members
{% endmacro %}

{% macro bigquery__iam_service_account_admin_priv(framework, check_id) %}
with
    project_policy_roles as (
        select _cq_sync_time, project_id, JSON_EXTRACT_ARRAY(bindings) as binding_array
        from {{ full_table_name("gcp_resourcemanager_project_policies") }}
    ),
    role_members as (
        select
            _cq_sync_time,
            project_id,
            binding,
            JSON_VALUE(binding, '$.role') as role,
            JSON_EXTRACT_STRING_ARRAY(binding, '$.members') as member
         from project_policy_roles,
          UNNEST(binding_array) AS binding

    )
select
        ARRAY_TO_STRING(member, ', ') resource_id,
        _cq_sync_time as sync_time,
        '{{framework}}' as framework,
        '{{check_id}}' as check_id,
        'Ensure that Service Account has no Admin privileges (Automated)' as title,
        project_id as project_id,
        case
            when
                (
                    "role" in ('roles/editor', 'roles/owner')
                    or "role" LIKE ANY ('%Admin', '%admin')
                )
                and "member" like 'serviceAccount:%.iam.gserviceaccount.com'
            then 'fail'
            else 'pass'
        end as status
    from role_members
{% endmacro %}