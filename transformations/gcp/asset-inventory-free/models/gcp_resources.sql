--Add Intersect pg_tables to ignore views.
{% set gcp_tables %}
    {{ gcp_tables_dyn() }}
{% endset %}



-- Generate dynamic SQL statements
{% for row in run_query(gcp_tables) %}
    {% if row.table_name is not none and row.table_name != '' %}
        {{ gcp_asset_resources(row.table_name, row.project_id_exist, row.id_exist, row.region_exist, row.description_exist, row.name_exist) }}
        {% if not loop.last %} UNION ALL {% endif %}
    {% endif %}
{% endfor %}