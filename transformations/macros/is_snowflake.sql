{% macro is_snowflake() %}
  {% if target.type == 'snowflake' %}
    {{ return(true) }}
  {% else %}
    {{ return(false) }}
  {% endif %}
{% endmacro %}
