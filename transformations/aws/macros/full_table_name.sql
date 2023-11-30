{% macro full_table_name(table_name) %}
    {{target.database}}.{{target.schema}}.{{table_name}}
{% endmacro %}