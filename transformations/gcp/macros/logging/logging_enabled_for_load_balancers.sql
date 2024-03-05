{% macro logging_enabled_for_load_balancers(framework, check_id) %}
  {{ return(adapter.dispatch('logging_enabled_for_load_balancers')(framework, check_id)) }}
{% endmacro %}

{% macro default__logging_enabled_for_load_balancers(framework, check_id) %}{% endmacro %}

{% macro postgres__logging_enabled_for_load_balancers(framework, check_id) %}
select distinct
        m.name as resource_id,
        '{{ framework }}' as framework,
        '{{ check_id }}' as check_id,
        'Ensure Logging is enabled for HTTP(S) Load Balancer (Automated)'
        as title,
        m.project_id as project_id,
        case
            when
                s.log_config ->> 'enable' = 'true'
            then 'pass'
            else 'fail'
        end as status
    from gcp_compute_url_maps m
    left join gcp_compute_backend_services s on s.self_link = m.default_service
{% endmacro %}

{% macro snowflake__logging_enabled_for_load_balancers(framework, check_id) %}
select distinct
        m.name as resource_id,
        '{{ framework }}' as framework,
        '{{ check_id }}' as check_id,
        'Ensure Logging is enabled for HTTP(S) Load Balancer (Automated)'
        as title,
        m.project_id as project_id,
        case
            when
                s.log_config:enable = 'true'
            then 'pass'
            else 'fail'
        end as status
    from gcp_compute_url_maps m
    left join gcp_compute_backend_services s on s.self_link = m.default_service
{% endmacro %}

{% macro bigquery__logging_enabled_for_load_balancers(framework, check_id) %}
select distinct
        m.name as resource_id,
        '{{ framework }}' as framework,
        '{{ check_id }}' as check_id,
        'Ensure Logging is enabled for HTTP(S) Load Balancer (Automated)'
        as title,
        m.project_id as project_id,
        case
            when
                to_json_string(json_extract(s.log_config, '$.enable')) = 'true'
            then 'pass'
            else 'fail'
        end as status
    from {{ full_table_name("gcp_compute_url_maps") }} m
    left join {{ full_table_name("gcp_compute_backend_services") }} s on s.self_link = m.default_service
{% endmacro %}