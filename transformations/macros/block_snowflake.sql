{% macro block_snowflake() %}
  {% if target.type == 'snowflake' %}
    {{ return(false) }}
  {% else %}
    {{ return(true) }}
  {% endif %}
{% endmacro %}