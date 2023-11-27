{% macro is_snowflake() %}
  {% if target.name == 'snowflake' %}
    {{ return(true) }}
  {% else %}
    {{ return(false) }}
  {% endif %}
{% endmacro %}