--Add Intersect pg_tables to ignore views.
{% set gcp_tables %}
    SELECT tablename as table_name
    FROM pg_tables
    INTERSECT
    SELECT DISTINCT table_name
    FROM information_schema.columns
    WHERE table_name LIKE 'gcp_%s' and COLUMN_NAME = 'project_id'
    INTERSECT
    SELECT table_name
    FROM information_schema.columns
    WHERE table_name LIKE 'gcp_%s' and COLUMN_NAME = 'id';
{% endset %}



-- Generate dynamic SQL statements
{% for row in run_query(gcp_tables) %}
    {% if row.table_name is not none and row.table_name != '' %}
        {{ gcp_asset_resources(row.table_name) }}
        {% if not loop.last %} UNION ALL {% endif %}
    {% endif %}
{% endfor %}