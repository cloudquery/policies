{% set aws_tables %}
    {{ aws_tables_dyn() }}
{% endset %}

-- Generate dynamic SQL statements
{% for row in run_query(aws_tables) %}
    {% if row.table_name is not none and row.table_name != '' %}
        {{ aws_asset_resources(row.table_name, row.ARN_EXIST, row.ACCOUNT_ID_EXIST, row.REQUEST_ACCOUNT_ID_EXIST, row.REGION_EXIST, row.TAGS_EXIST) }}
        {% if not loop.last %} UNION ALL {% endif %}
    {% endif %}
{% endfor %}