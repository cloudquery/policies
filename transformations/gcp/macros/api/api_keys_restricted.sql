{% macro api_keys_restricted(framework, check_id) %}
  {{ return(adapter.dispatch('api_keys_restricted')(framework, check_id)) }}
{% endmacro %}

{% macro default__api_keys_restricted(framework, check_id) %}{% endmacro %}

{% macro postgres__api_keys_restricted(framework, check_id) %}
select distinct
        name as resource_id,
        '{{ framework }}' as framework,
        '{{ check_id }}' as check_id,
        'Ensure API Keys Are Restricted To Use by Only Specified Hosts and Apps'
        as title,
        project_id as project_id,
        case
            when
                restrictions is null 
				or restrictions -> 'ClientRestrictions' is null 
				or restrictions -> 'ClientRestrictions' -> 'BrowserKeyRestrictions' ->> 'allowed_referrers' like '%*%'
				or restrictions -> 'ClientRestrictions' -> 'ServerKeyRestrictions' ->> 'allowed_ips' in ('0.0.0.0', '0.0.0.0/0', '::0')
            then 'fail'
            else 'pass'
        end as status
    from gcp_apikeys_keys 

{% endmacro %}

{% macro snowflake__api_keys_restricted(framework, check_id) %}
select distinct
        name as resource_id,
        '{{ framework }}' as framework,
        '{{ check_id }}' as check_id,
        'Ensure API Keys Are Restricted To Use by Only Specified Hosts and Apps'
        as title,
        project_id as project_id,
        case
            when
                restrictions is null 
				or restrictions -> 'ClientRestrictions' is null 
				or restrictions -> 'ClientRestrictions' -> 'BrowserKeyRestrictions' ->> 'allowed_referrers' like '%*%'
				or restrictions -> 'ClientRestrictions' -> 'ServerKeyRestrictions' ->> 'allowed_ips' in ('0.0.0.0', '0.0.0.0/0', '::0')
            then 'fail'
            else 'pass'
        end as status
    from gcp_apikeys_keys 
    
{% endmacro %}

{% macro bigquery__api_keys_restricted(framework, check_id) %}
select distinct
        name as resource_id,
        '{{ framework }}' as framework,
        '{{ check_id }}' as check_id,
        'Ensure API Keys Are Restricted To Use by Only Specified Hosts and Apps'
        as title,
        project_id as project_id,
        case
            when
                restrictions is null 
				or restrictions -> 'ClientRestrictions' is null 
				or restrictions -> 'ClientRestrictions' -> 'BrowserKeyRestrictions' ->> 'allowed_referrers' like '%*%'
				or restrictions -> 'ClientRestrictions' -> 'ServerKeyRestrictions' ->> 'allowed_ips' in ('0.0.0.0', '0.0.0.0/0', '::0')
            then 'fail'
            else 'pass'
        end as status
    from {{ full_table_name("gcp_apikeys_keys") }} 

{% endmacro %}