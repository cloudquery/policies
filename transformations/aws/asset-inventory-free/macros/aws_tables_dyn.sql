{% macro aws_tables_dyn() %}
  {{ return(adapter.dispatch('aws_tables_dyn')()) }}
{% endmacro %}

{% macro postgres__aws_tables_dyn() %}
    SELECT table_name as "table_name"
    FROM information_schema.tables where table_type = 'BASE TABLE'
    INTERSECT
    SELECT DISTINCT table_name
    FROM information_schema.columns
    WHERE table_name ILIKE 'aws_%s' and lower(COLUMN_NAME) IN ('account_id', 'request_account_id')
    INTERSECT
    SELECT table_name
    FROM information_schema.columns
    WHERE table_name ILIKE 'aws_%s' and lower(COLUMN_NAME) = 'arn'

{% endmacro %}    

{% macro snowflake__aws_tables_dyn() %}
    SELECT table_name as "table_name"
    FROM information_schema.tables where table_type = 'BASE TABLE'
    INTERSECT
    SELECT DISTINCT table_name
    FROM information_schema.columns
    WHERE table_name ILIKE 'aws_%s' and lower(COLUMN_NAME) IN ('account_id', 'request_account_id')
    INTERSECT
    SELECT table_name
    FROM information_schema.columns
    WHERE table_name ILIKE 'aws_%s' and lower(COLUMN_NAME) = 'arn'

{% endmacro %} 

{% macro bigquery__aws_tables_dyn() %}

    WITH base_tables AS (
    SELECT table_schema, table_name
    FROM {{ full_table_name("INFORMATION_SCHEMA.TABLES") }}
    WHERE table_type = 'BASE TABLE'
    ),
    aws_specific_columns AS (
    SELECT table_schema, table_name
    FROM {{ full_table_name("INFORMATION_SCHEMA.COLUMNS") }}
    WHERE (table_name LIKE 'aws_%s')
    AND LOWER(column_name) IN ('account_id', 'request_account_id')
    UNION DISTINCT
    SELECT table_schema, table_name
    FROM {{ full_table_name("INFORMATION_SCHEMA.COLUMNS") }}
    WHERE (table_name LIKE 'aws_%s')
    AND LOWER(column_name) = 'arn'
    )
    SELECT DISTINCT bt.table_name
    FROM base_tables bt
    JOIN aws_specific_columns ft
    ON bt.table_schema = ft.table_schema AND bt.table_name = ft.table_name
    LIMIT 2

{% endmacro %}  