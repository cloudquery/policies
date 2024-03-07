{% macro iam_essential_contacts_configured(framework, check_id) %}
  {{ return(adapter.dispatch('iam_essential_contacts_configured')(framework, check_id)) }}
{% endmacro %}

{% macro default__iam_essential_contacts_configured(framework, check_id) %}{% endmacro %}

{% macro postgres__iam_essential_contacts_configured(framework, check_id) %}
select distinct
        name as resource_id,
        '{{ framework }}' as framework,
        '{{ check_id }}' as check_id,
        'Ensure Essential Contacts is Configured for Organization (Automated)'
        as title,
        project_id as project_id,
        case
            when
                email is null 
				and notification_category_subscriptions::text not like all (array['%SUSPENSION%','%SECURITY%','%TECHNICAL%','%LEGAL%']) 
				and validation_state != 'VALID'
            then 'fail'
            else 'pass'
        end as status
    from gcp_essentialcontacts_project_contacts 
    union all
select distinct
        name as resource_id,
        '{{ framework }}' as framework,
        '{{ check_id }}' as check_id,
        'Ensure Essential Contacts is Configured for Organization (Automated)'
        as title,
        organization_id as project_id,
        case
            when
                email is null 
				and notification_category_subscriptions::text not like all (array['%SUSPENSION%','%SECURITY%','%TECHNICAL%','%LEGAL%']) 
				and validation_state != 'VALID'
            then 'fail'
            else 'pass'
        end as status
    from gcp_essentialcontacts_organization_contacts 
        union all
select distinct
        name as resource_id,
        '{{ framework }}' as framework,
        '{{ check_id }}' as check_id,
        'Ensure Essential Contacts is Configured for Organization (Automated)'
        as title,
        folder_id as project_id,
        case
            when
                email is null 
				and notification_category_subscriptions::text not like all (array['%SUSPENSION%','%SECURITY%','%TECHNICAL%','%LEGAL%']) 
				and validation_state != 'VALID'
            then 'fail'
            else 'pass'
        end as status
    from gcp_essentialcontacts_folder_contacts 

{% endmacro %}

{% macro snowflake__iam_essential_contacts_configured(framework, check_id) %}
select distinct
        name as resource_id,
        '{{ framework }}' as framework,
        '{{ check_id }}' as check_id,
        'Ensure Essential Contacts is Configured for Organization (Automated)'
        as title,
        project_id as project_id,
        case
            when
                email is null 
				and not (notification_category_subscriptions::text like all ('%SUSPENSION%','%SECURITY%','%TECHNICAL%','%LEGAL%')) 
				and validation_state != 'VALID'
            then 'fail'
            else 'pass'
        end as status
    from gcp_essentialcontacts_project_contacts 
    union all
select distinct
        name as resource_id,
        '{{ framework }}' as framework,
        '{{ check_id }}' as check_id,
        'Ensure Essential Contacts is Configured for Organization (Automated)'
        as title,
        organization_id as project_id,
        case
            when
                email is null 
				and not (notification_category_subscriptions::text like all ('%SUSPENSION%','%SECURITY%','%TECHNICAL%','%LEGAL%'))
				and validation_state != 'VALID'
            then 'fail'
            else 'pass'
        end as status
    from gcp_essentialcontacts_organization_contacts 
        union all
select distinct
        name as resource_id,
        '{{ framework }}' as framework,
        '{{ check_id }}' as check_id,
        'Ensure Essential Contacts is Configured for Organization (Automated)'
        as title,
        folder_id as project_id,
        case
            when
                email is null 
				and not (notification_category_subscriptions::text like all ('%SUSPENSION%','%SECURITY%','%TECHNICAL%','%LEGAL%')) 
				and validation_state != 'VALID'
            then 'fail'
            else 'pass'
        end as status
    from gcp_essentialcontacts_folder_contacts 
    
{% endmacro %}

{% macro bigquery__iam_essential_contacts_configured(framework, check_id) %}
select distinct
        name as resource_id,
        '{{ framework }}' as framework,
        '{{ check_id }}' as check_id,
        'Ensure Essential Contacts is Configured for Organization (Automated)'
        as title,
        project_id as project_id,
        case
            when
                email is null 
				and not (array_to_string(notification_category_subscriptions, ",") like all ('%SUSPENSION%','%SECURITY%','%TECHNICAL%','%LEGAL%')) 
				and validation_state != 'VALID'
            then 'fail'
            else 'pass'
        end as status
    from {{ full_table_name("gcp_essentialcontacts_project_contacts") }} 
    union all
select distinct
        name as resource_id,
        '{{ framework }}' as framework,
        '{{ check_id }}' as check_id,
        'Ensure Essential Contacts is Configured for Organization (Automated)'
        as title,
        organization_id as project_id,
        case
            when
                email is null 
				and not (array_to_string(notification_category_subscriptions, ",") like all ('%SUSPENSION%','%SECURITY%','%TECHNICAL%','%LEGAL%'))
				and validation_state != 'VALID'
            then 'fail'
            else 'pass'
        end as status
    from {{ full_table_name("gcp_essentialcontacts_organization_contacts") }} 
        union all
select distinct
        name as resource_id,
        '{{ framework }}' as framework,
        '{{ check_id }}' as check_id,
        'Ensure Essential Contacts is Configured for Organization (Automated)'
        as title,
        folder_id as project_id,
        case
            when
                email is null 
				and not (array_to_string(notification_category_subscriptions, ",") like all ('%SUSPENSION%','%SECURITY%','%TECHNICAL%','%LEGAL%'))
				and validation_state != 'VALID'
            then 'fail'
            else 'pass'
        end as status
    from {{ full_table_name("gcp_essentialcontacts_folder_contacts") }}  

{% endmacro %}