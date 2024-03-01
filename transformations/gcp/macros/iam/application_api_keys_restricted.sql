{% macro application_api_keys_restricted(framework, check_id) %}
  {{ return(adapter.dispatch('application_api_keys_restricted')(framework, check_id)) }}
{% endmacro %}

{% macro default__application_api_keys_restricted(framework, check_id) %}{% endmacro %}

{% macro postgres__application_api_keys_restricted(framework, check_id) %}
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

{% macro snowflake__application_api_keys_restricted(framework, check_id) %}
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

{% macro bigquery__application_api_keys_restricted(framework, check_id) %}
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
    from {{ full_table_name("gcp_apikeys_keys") }} 

{% endmacro %}