{% macro iam_application_api_keys_restricted(framework, check_id) %}
  {{ return(adapter.dispatch('iam_application_api_keys_restricted')(framework, check_id)) }}
{% endmacro %}

{% macro default__iam_application_api_keys_restricted(framework, check_id) %}{% endmacro %}

{% macro postgres__iam_application_api_keys_restricted(framework, check_id) %}
select distinct
        name as resource_id,
        '{{ framework }}' as framework,
        '{{ check_id }}' as check_id,
        'Ensure API Keys Are Restricted to Only APIs That Application Needs Access (Automated)'
        as title,
        project_id as project_id,
        case
            when
                restrictions is null 
				or restrictions -> 'api_targets' is null 
				or restrictions ->> 'api_targets' like '%cloudapis.googleapis.com%'
            then 'fail'
            else 'pass'
        end as status
    from gcp_apikeys_keys 

{% endmacro %}

{% macro snowflake__iam_application_api_keys_restricted(framework, check_id) %}
select distinct
        name as resource_id,
        '{{ framework }}' as framework,
        '{{ check_id }}' as check_id,
        'Ensure API Keys Are Restricted to Only APIs That Application Needs Access (Automated)'
        as title,
        project_id as project_id,
        case
            when
                restrictions is null 
				or restrictions:api_targets is null 
				or restrictions:api_targets like '%cloudapis.googleapis.com%'
            then 'fail'
            else 'pass'
        end as status
    from gcp_apikeys_keys 
    
{% endmacro %}

{% macro bigquery__iam_application_api_keys_restricted(framework, check_id) %}
select distinct
        name as resource_id,
        '{{ framework }}' as framework,
        '{{ check_id }}' as check_id,
        'Ensure API Keys Are Restricted to Only APIs That Application Needs Access (Automated)'
        as title,
        project_id as project_id,
        case
            when
                restrictions is null 
				or json_extract(restrictions ,'$.api_targets') is null 
				or to_json_string(json_extract(restrictions, '$.api_targets')) like '%cloudapis.googleapis.com%'
            then 'fail'
            else 'pass'
        end as status
    from {{ full_table_name("gcp_apikeys_keys") }} 

{% endmacro %}