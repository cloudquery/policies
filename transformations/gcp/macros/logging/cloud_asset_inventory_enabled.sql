{% macro logging_cloud_asset_inventory_enabled(framework, check_id) %}
  {{ return(adapter.dispatch('logging_cloud_asset_inventory_enabled')(framework, check_id)) }}
{% endmacro %}

{% macro default__logging_cloud_asset_inventory_enabled(framework, check_id) %}{% endmacro %}

{% macro postgres__logging_cloud_asset_inventory_enabled(framework, check_id) %}
select distinct
        name as resource_id,
        '{{ framework }}' as framework,
        '{{ check_id }}' as check_id,
        'Ensure Cloud Asset Inventory Is Enabled (Automated)'
        as title,
        project_id as project_id,
        case
            when
                state != 'ENABLED'
            then 'fail'
            else 'pass'
        end as status
    from gcp_serviceusage_services
	where name like '%cloudasset.googleapis.com'
{% endmacro %}

{% macro snowflake__logging_cloud_asset_inventory_enabled(framework, check_id) %}
select distinct
        name as resource_id,
        '{{ framework }}' as framework,
        '{{ check_id }}' as check_id,
        'Ensure Cloud Asset Inventory Is Enabled (Automated)'
        as title,
        project_id as project_id,
        case
            when
                state != 'ENABLED'
            then 'fail'
            else 'pass'
        end as status
    from gcp_serviceusage_services
	where name like '%cloudasset.googleapis.com'
{% endmacro %}

{% macro bigquery__logging_cloud_asset_inventory_enabled(framework, check_id) %}
select distinct
        name as resource_id,
        '{{ framework }}' as framework,
        '{{ check_id }}' as check_id,
        'Ensure Cloud Asset Inventory Is Enabled (Automated)'
        as title,
        project_id as project_id,
        case
            when
                state != 'ENABLED'
            then 'fail'
            else 'pass'
        end as status
    FROM {{ full_table_name("gcp_serviceusage_services") }}
    where name like '%cloudasset.googleapis.com'
{% endmacro %}