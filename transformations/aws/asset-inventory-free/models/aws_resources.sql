--removed pg tables reference for compatibility, using information_schema and table_type instead to filter out views
{% set aws_tables %}
    SELECT table_name as "table_name"
    FROM information_schema.tables where table_type = 'BASE TABLE'
    INTERSECT
    SELECT DISTINCT table_name
    FROM information_schema.columns
    WHERE table_name ILIKE 'aws_%s' and lower(COLUMN_NAME) IN ('account_id', 'request_account_id')
    INTERSECT
    SELECT table_name
    FROM information_schema.columns
    WHERE table_name ILIKE 'aws_%s' and lower(COLUMN_NAME) = 'arn';
{% endset %}



-- Generate dynamic SQL statements
{% for row in run_query(aws_tables) %}
    {% if row.table_name is not none and row.table_name != '' %}
        {{ aws_asset_resources(row.table_name) }}
        {% if not loop.last %} UNION ALL {% endif %}
    {% endif %}
{% endfor %}