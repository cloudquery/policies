{% set aws_tables %}
    {{ aws_tables_dyn() }}
{% endset %}

-- Generate dynamic SQL statements
{% for row in run_query(aws_tables) %}
    {% if row.table_name is not none and row.table_name != '' %}
        {{ aws_asset_resources(row.table_name) }}
        {% if not loop.last %} {{ union() }} {% endif %}
    {% endif %}
{% endfor %}