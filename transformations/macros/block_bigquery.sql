{% macro block_bigquery() %}
  {% if target.type == 'bigquery' %}
    {{ return(false) }}
  {% else %}
    {{ return(true) }}
  {% endif %}
{% endmacro %}