{% macro union() %}
  {% if target.type == 'bigquery' %}
    union all
  {% else %}
    union
  {% endif %}
{% endmacro %}