{% macro aws_tables_dyn() %}
  {{ return(adapter.dispatch('aws_tables_dyn')()) }}
{% endmacro %}

{% macro postgres__aws_tables_dyn() %}
SELECT 
    t.table_name,
    MAX(CASE WHEN UPPER(c.column_name) = 'ARN' THEN 1 ELSE 0 END) AS arn_exist,
    MAX(CASE WHEN UPPER(c.column_name) = 'ACCOUNT_ID' THEN 1 ELSE 0 END) AS account_id_exist,
    MAX(CASE WHEN UPPER(c.column_name) = 'REQUEST_ACCOUNT_ID' THEN 1 ELSE 0 END) AS request_account_id_exist,
    MAX(CASE WHEN UPPER(c.column_name) = 'REGION' THEN 1 ELSE 0 END) AS region_exist,
    MAX(CASE WHEN UPPER(c.column_name) = 'TAGS' THEN 1 ELSE 0 END) AS tags_exist  
FROM 
    INFORMATION_SCHEMA.TABLES t
LEFT JOIN 
    INFORMATION_SCHEMA.COLUMNS c ON t.table_name = c.table_name AND t.table_schema = c.table_schema
WHERE
    t.table_type = 'BASE TABLE' AND t.table_name LIKE 'aws_%s'
GROUP BY 
    t.table_name
HAVING
    MAX(CASE WHEN UPPER(c.column_name) = 'ARN' THEN 1 ELSE 0 END)::bool
    AND (MAX(CASE WHEN UPPER(c.column_name) = 'ACCOUNT_ID' THEN 1 ELSE 0 END)::bool OR MAX(CASE WHEN UPPER(c.column_name) = 'REQUEST_ACCOUNT_ID' THEN 1 ELSE 0 END)::bool)

{% endmacro %}    

{% macro snowflake__aws_tables_dyn() %}
SELECT 
    t.table_name as "table_name",
    MAX(CASE WHEN UPPER(c.column_name) = 'ARN' THEN 1 ELSE 0 END) AS "arn_exist",
    MAX(CASE WHEN UPPER(c.column_name) = 'ACCOUNT_ID' THEN 1 ELSE 0 END) AS "account_id_exist",
    MAX(CASE WHEN UPPER(c.column_name) = 'REQUEST_ACCOUNT_ID' THEN 1 ELSE 0 END) AS "request_account_id_exist",
    MAX(CASE WHEN UPPER(c.column_name) = 'REGION' THEN 1 ELSE 0 END) AS "region_exist",
    MAX(CASE WHEN UPPER(c.column_name) = 'TAGS' THEN 1 ELSE 0 END) AS "tags_exist"
FROM 
    INFORMATION_SCHEMA.TABLES t
LEFT JOIN 
    INFORMATION_SCHEMA.COLUMNS c ON t.table_name = c.table_name AND t.table_schema = c.table_schema
WHERE
    t.table_type = 'BASE TABLE' AND t.table_name ILIKE 'aws_%s'
GROUP BY 
    t.table_name
HAVING
    MAX(CASE WHEN UPPER(c.column_name) = 'ARN' THEN 1 ELSE 0 END)::boolean
    AND (MAX(CASE WHEN UPPER(c.column_name) = 'ACCOUNT_ID' THEN 1 ELSE 0 END)::boolean OR MAX(CASE WHEN UPPER(c.column_name) = 'REQUEST_ACCOUNT_ID' THEN 1 ELSE 0 END)::boolean)

{% endmacro %} 

{% macro bigquery__aws_tables_dyn() %}

SELECT 
    t.table_name,
    MAX(CASE WHEN UPPER(c.column_name) = 'ARN' THEN 1 ELSE 0 END) AS arn_exist,
    MAX(CASE WHEN UPPER(c.column_name) = 'ACCOUNT_ID' THEN 1 ELSE 0 END) AS account_id_exist,
    MAX(CASE WHEN UPPER(c.column_name) = 'REQUEST_ACCOUNT_ID' THEN 1 ELSE 0 END) AS request_account_id_exist,
    MAX(CASE WHEN UPPER(c.column_name) = 'REGION' THEN 1 ELSE 0 END) AS region_exist,
    MAX(CASE WHEN UPPER(c.column_name) = 'TAGS' THEN 1 ELSE 0 END) AS tags_exist
FROM 
    {{ full_table_name("INFORMATION_SCHEMA.TABLES") }} t
INNER JOIN 
    {{ full_table_name("INFORMATION_SCHEMA.COLUMNS") }} c ON t.table_name = c.table_name AND t.table_schema = c.table_schema
WHERE
    t.table_type = 'BASE TABLE' AND t.table_name LIKE 'aws_%s'
GROUP BY 
    t.table_name
HAVING
    CAST(MAX(CASE WHEN UPPER(c.column_name) = 'ARN' THEN 1 ELSE 0 END) AS BOOL)
    AND (CAST(MAX(CASE WHEN UPPER(c.column_name) = 'ACCOUNT_ID' THEN 1 ELSE 0 END) as BOOL) OR CAST(MAX(CASE WHEN UPPER(c.column_name) = 'REQUEST_ACCOUNT_ID' THEN 1 ELSE 0 END) AS BOOL))

{% endmacro %}  