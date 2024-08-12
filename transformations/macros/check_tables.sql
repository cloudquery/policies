/* DBT-PACK-ALWAYS-INCLUDE-IN-ZIP */
{% macro check_tables_exist(variable_name) %}
    {% set tables = var(variable_name, []) %}
    {% for table in tables %}
        {% set query %}
            SELECT COUNT(*)
            FROM information_schema.tables
            WHERE table_schema = '{{ target.schema }}'
            AND table_name = '{{ table }}'
        {% endset %}
        {% set result = run_query(query) %}
        {% if result %}
            {% set table_exists = result.rows[0][0] | int > 0 %}
            {% if not table_exists %}
                {{ log("Table '" ~ table ~ "' does not exist in schema '" ~ target.schema ~ "'.", "error") }}
            {% endif %}
        {% else %}
            {{ log("Could not check existence of table '" ~ table ~ "'.", "warn") }}
        {% endif %}
    {% endfor %}
{% endmacro %}