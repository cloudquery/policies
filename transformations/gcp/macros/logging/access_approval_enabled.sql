{% macro logging_access_approval_enabled(framework, check_id) %}
  {{ return(adapter.dispatch('logging_access_approval_enabled')(framework, check_id)) }}
{% endmacro %}

{% macro default__logging_access_approval_enabled(framework, check_id) %}{% endmacro %}

{% macro postgres__logging_access_approval_enabled(framework, check_id) %}
select distinct
        name as resource_id,
        '{{ framework }}' as framework,
        '{{ check_id }}' as check_id,
        'Ensure "Access Approval" is "Enabled"'
        as title,
        project_id as project_id,
        case
            when
                notification_emails is null
            then 'fail'
            else 'pass'
        end as status
    from gcp_accessapproval_project_settings
union all
select distinct
        name as resource_id,
        '{{ framework }}' as framework,
        '{{ check_id }}' as check_id,
        'Ensure "Access Approval" is "Enabled"'
        as title,
        organization_id as project_id,
        case
            when
                notification_emails is null
            then 'fail'
            else 'pass'
        end as status
    from gcp_accessapproval_organization_settings
union all
select distinct
        name as resource_id,
        '{{ framework }}' as framework,
        '{{ check_id }}' as check_id,
        'Ensure "Access Approval" is "Enabled"'
        as title,
        folder_id as project_id,
        case
            when
                notification_emails is null
            then 'fail'
            else 'pass'
        end as status
    from gcp_accessapproval_folder_settings
{% endmacro %}

{% macro snowflake__logging_access_approval_enabled(framework, check_id) %}
select distinct
        name as resource_id,
        '{{ framework }}' as framework,
        '{{ check_id }}' as check_id,
        'Ensure "Access Approval" is "Enabled"'
        as title,
        project_id as project_id,
        case
            when
                notification_emails is null
            then 'fail'
            else 'pass'
        end as status
    from gcp_accessapproval_project_settings
union all
select distinct
        name as resource_id,
        '{{ framework }}' as framework,
        '{{ check_id }}' as check_id,
        'Ensure "Access Approval" is "Enabled"'
        as title,
        organization_id as project_id,
        case
            when
                notification_emails is null
            then 'fail'
            else 'pass'
        end as status
    from gcp_accessapproval_organization_settings
union all
select distinct
        name as resource_id,
        '{{ framework }}' as framework,
        '{{ check_id }}' as check_id,
        'Ensure "Access Approval" is "Enabled"'
        as title,
        folder_id as project_id,
        case
            when
                notification_emails is null
            then 'fail'
            else 'pass'
        end as status
{% endmacro %}

{% macro bigquery__logging_access_approval_enabled(framework, check_id) %}
select distinct
        name as resource_id,
        '{{ framework }}' as framework,
        '{{ check_id }}' as check_id,
        'Ensure "Access Approval" is "Enabled"'
        as title,
        project_id as project_id,
        case
            when
                notification_emails is null
            then 'fail'
            else 'pass'
        end as status
    from g{{ full_table_name("gcp_accessapproval_project_settings") }}
union all
select distinct
        name as resource_id,
        '{{ framework }}' as framework,
        '{{ check_id }}' as check_id,
        'Ensure "Access Approval" is "Enabled"'
        as title,
        organization_id as project_id,
        case
            when
                notification_emails is null
            then 'fail'
            else 'pass'
        end as status
    from {{ full_table_name("gcp_accessapproval_organization_settings") }}
union all
select distinct
        name as resource_id,
        '{{ framework }}' as framework,
        '{{ check_id }}' as check_id,
        'Ensure "Access Approval" is "Enabled"'
        as title,
        folder_id as project_id,
        case
            when
                notification_emails is null
            then 'fail'
            else 'pass'
        end as status
    from {{ full_table_name("gcp_accessapproval_folder_settings") }}
{% endmacro %}