{% macro block_postgres() %}
  {% if target.type == 'postgres' %}
    {{ return(false) }}
  {% else %}
    {{ return(true) }}
  {% endif %}
{% endmacro %}