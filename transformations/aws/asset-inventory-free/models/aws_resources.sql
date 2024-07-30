{% set aws_tables %}
    {{ aws_tables_dyn() }}
{% endset %}

-- Generate dynamic SQL statements
{% for row in run_query(aws_tables) -%}
    {% if row.table_name is not none and row.table_name != '' -%}
        {{ aws_asset_resources(row.table_name, row.arn_exist, row.account_id_exist, row.request_account_id_exist, row.region_exist, row.tags_exist) }}
        {% if not loop.last -%} UNION ALL {% endif -%}
    {%- endif %}
{%- endfor %}