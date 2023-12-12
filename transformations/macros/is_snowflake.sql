{% macro is_snowflake() %}
  {% if target.database == 'snowflake' %}
    {{ return(true) }}
  {% else %}
    {{ return(false) }}
  {% endif %}
{% endmacro %}