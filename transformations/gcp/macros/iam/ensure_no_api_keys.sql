{% macro iam_ensure_no_api_keys(framework, check_id) %}
  {{ return(adapter.dispatch('iam_ensure_no_api_keys')(framework, check_id)) }}
{% endmacro %}

{% macro default__iam_ensure_no_api_keys(framework, check_id) %}{% endmacro %}

{% macro postgres__iam_ensure_no_api_keys(framework, check_id) %}
select distinct
        name as resource_id,
        '{{ framework }}' as framework,
        '{{ check_id }}' as check_id,
        'Ensure API Keys Only Exist for Active Services (Automated)'
        as title,
        project_id as project_id,
        case
            when
                delete_time is null
            then 'fail'
            else 'pass'
        end as status
    from gcp_apikeys_keys 

{% endmacro %}

{% macro snowflake__iam_ensure_no_api_keys(framework, check_id) %}
select distinct
        name as resource_id,
        '{{ framework }}' as framework,
        '{{ check_id }}' as check_id,
        'Ensure API Keys Only Exist for Active Services (Automated)'
        as title,
        project_id as project_id,
        case
            when
                delete_time is null
            then 'fail'
            else 'pass'
        end as status
    from gcp_apikeys_keys 
    
{% endmacro %}

{% macro bigquery__iam_ensure_no_api_keys(framework, check_id) %}
select distinct
        name as resource_id,
        '{{ framework }}' as framework,
        '{{ check_id }}' as check_id,
        'Ensure API Keys Only Exist for Active Services (Automated)'
        as title,
        project_id as project_id,
        case
            when
                delete_time is null
            then 'fail'
            else 'pass'
        end as status
    from {{ full_table_name("gcp_apikeys_keys") }} 

{% endmacro %}