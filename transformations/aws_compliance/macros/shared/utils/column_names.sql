{% macro extract_column_names(columns) %}
    {% set list_of_relations = [] %}
    {% for name in names %}
        {% set relation = something(name) %}
        {% do list_of_relations.append(relation) %}
    {% endfor %}
    {{ return(list_of_relations) }}
{% endmacro %}