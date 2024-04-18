--Add Intersect pg_tables to ignore views.
{% set azure_tables %}
    {{ azure_tables_dyn() }}
{% endset %}



-- Generate dynamic SQL statements
{% for row in run_query(azure_tables) %}
    {% if row.table_name is not none and row.table_name != '' %}
        {{ azure_asset_resources(row.table_name, row.subscription_id_exist, row.id_exist, row.location_exist, row.kind_exist, row.name_exist) }}
        {% if not loop.last %} UNION ALL {% endif %}
    {% endif %}
{% endfor %}