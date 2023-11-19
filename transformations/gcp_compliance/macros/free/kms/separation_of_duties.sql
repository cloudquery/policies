{% macro kms_separation_of_duties(framework, check_id) %}
  {{ return(adapter.dispatch('kms_separation_of_duties')(framework, check_id)) }}
{% endmacro %}

{% macro default__kms_separation_of_duties(framework, check_id) %}{% endmacro %}

{% macro postgres__kms_separation_of_duties(framework, check_id) %}
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
    ),
    member_with_roles as (
        select _cq_sync_time, project_id, member, array_agg(role) as roles
        from role_members
        group by _cq_sync_time, member, project_id
    )
select
        member as resource_id,
        _cq_sync_time as sync_time,
        '{{framework}}' as framework,
        '{{check_id}}' as check_id,
        'Ensure that Separation of duties is enforced while assigning KMS related roles to users (Automated)'
        as title,
        project_id as project_id,
        case
            when
                member like 'user:%'
                and 'roles/cloudkms.admin' = any(roles)
                and roles && array[
                    'roles/cloudkms.cryptoKeyEncrypterDecrypter',
                    'roles/cloudkms.cryptoKeyEncrypter',
                    'roles/cloudkms.cryptoKeyDecrypter'
                ]
            then 'fail'
            else 'pass'
        end as status
    from member_with_roles
{% endmacro %}

{% macro snowflake__kms_separation_of_duties(framework, check_id) %}
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
    ),
    member_with_roles as (
        select _cq_sync_time, project_id, member, array_agg(role) as roles
        from role_members
        group by _cq_sync_time, member, project_id
    )
select
        member::text as resource_id,
        _cq_sync_time as sync_time,
        '{{framework}}' as framework,
        '{{check_id}}' as check_id,
        'Ensure that Separation of duties is enforced while assigning KMS related roles to users (Automated)'
        as title,
        project_id as project_id,
        case
            when
                member like 'user:%'
                AND ARRAY_CONTAINS('roles/cloudkms.admin'::variant, roles)
                AND ARRAYS_OVERLAP(roles, 
                      array_construct('roles/cloudkms.cryptoKeyEncrypterDecrypter',
                    'roles/cloudkms.cryptoKeyEncrypter',
                    'roles/cloudkms.cryptoKeyDecrypter'))
            then 'fail'
            else 'pass'
        end as status
    from member_with_roles
{% endmacro %}

{% macro bigquery__kms_separation_of_duties(framework, check_id) %}
--
{% endmacro %}