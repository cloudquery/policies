{% macro gen_timestamp() %}
  {% if target.type == 'bigquery' or target.type == 'athena' %}
    CAST('{{ run_started_at }}' AS timestamp) as policy_execution_time
  {% else %}
    ('{{ run_started_at }}')::timestamp as policy_execution_time
  {% endif %}
{% endmacro %}
