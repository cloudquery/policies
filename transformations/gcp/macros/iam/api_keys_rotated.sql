{% macro iam_api_keys_rotated(framework, check_id) %}
  {{ return(adapter.dispatch('iam_api_keys_rotated')(framework, check_id)) }}
{% endmacro %}

{% macro default__iam_api_keys_rotated(framework, check_id) %}{% endmacro %}

{% macro postgres__iam_api_keys_rotated(framework, check_id) %}
select distinct
        name as resource_id,
        '{{ framework }}' as framework,
        '{{ check_id }}' as check_id,
        'Ensure API Keys Are Restricted to Only APIs That Application Needs Access (Automated)'
        as title,
        project_id as project_id,
        case
            when
                create_time::date < (current_date - 90)
            then 'fail'
            else 'pass'
        end as status
    from gcp_apikeys_keys 

{% endmacro %}

{% macro snowflake__iam_api_keys_rotated(framework, check_id) %}
select distinct
        name as resource_id,
        '{{ framework }}' as framework,
        '{{ check_id }}' as check_id,
        'Ensure API Keys Are Restricted to Only APIs That Application Needs Access (Automated)'
        as title,
        project_id as project_id,
        case
            when
                create_time::date < (current_date - 90)
            then 'fail'
            else 'pass'
        end as status
    from gcp_apikeys_keys 
    
{% endmacro %}

{% macro bigquery__iam_api_keys_rotated(framework, check_id) %}
select distinct
        name as resource_id,
        '{{ framework }}' as framework,
        '{{ check_id }}' as check_id,
        'Ensure API Keys Are Restricted to Only APIs That Application Needs Access (Automated)'
        as title,
        project_id as project_id,
        case
            when
                cast(create_time as date) < (current_date - 90)
            then 'fail'
            else 'pass'
        end as status
    from {{ full_table_name("gcp_apikeys_keys") }} 

{% endmacro %}