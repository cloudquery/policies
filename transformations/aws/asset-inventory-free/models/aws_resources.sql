--Add Intersect pg_tables to ignore views.
{% set aws_tables %}
    SELECT tablename as table_name
    FROM pg_tables
    INTERSECT
    SELECT DISTINCT table_name
    FROM information_schema.columns
    WHERE table_name LIKE 'aws_%s' and COLUMN_NAME IN ('account_id', 'request_account_id')
    INTERSECT
    SELECT table_name
    FROM information_schema.columns
    WHERE table_name LIKE 'aws_%s' and COLUMN_NAME = 'arn';
{% endset %}



-- Generate dynamic SQL statements
{% for row in run_query(aws_tables) %}
    {% if row.table_name is not none and row.table_name != '' %}
        {{ aws_asset_resources(row.table_name) }}
        {% if not loop.last %} UNION ALL {% endif %}
    {% endif %}
{% endfor %}