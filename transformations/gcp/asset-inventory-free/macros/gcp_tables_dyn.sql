{% macro gcp_tables_dyn() %}
  {{ return(adapter.dispatch('gcp_tables_dyn')()) }}
{% endmacro %}

{% macro postgres__gcp_tables_dyn() %}
SELECT 
    t.table_name,
    MAX(CASE WHEN UPPER(c.column_name) = 'PROJECT_ID' THEN 1 ELSE 0 END) AS project_id_exist,
    MAX(CASE WHEN UPPER(c.column_name) = 'ID' THEN 1 ELSE 0 END) AS id_exist,
    MAX(CASE WHEN UPPER(c.column_name) = 'REGION' THEN 1 ELSE 0 END) AS region_exist,
    MAX(CASE WHEN UPPER(c.column_name) = 'DESCRIPTION' THEN 1 ELSE 0 END) AS description_exist,
    MAX(CASE WHEN UPPER(c.column_name) = 'NAME' THEN 1 ELSE 0 END) AS name_exist  
FROM 
    INFORMATION_SCHEMA.TABLES t
LEFT JOIN 
    INFORMATION_SCHEMA.COLUMNS c ON t.table_name = c.table_name AND t.table_schema = c.table_schema
WHERE
    t.table_type = 'BASE TABLE' AND t.table_name LIKE 'gcp_%s'
GROUP BY 
    t.table_name
HAVING
    MAX(CASE WHEN UPPER(c.column_name) = 'PROJECT_ID' THEN 1 ELSE 0 END)::bool
    AND (MAX(CASE WHEN UPPER(c.column_name) = 'ID' THEN 1 ELSE 0 END)::bool)

{% endmacro %}    

{% macro snowflake__gcp_tables_dyn() %}
SELECT 
    t.table_name as "table_name",
    MAX(CASE WHEN UPPER(c.column_name) = 'PROJECT_ID' THEN 1 ELSE 0 END) AS project_id_exist,
    MAX(CASE WHEN UPPER(c.column_name) = 'ID' THEN 1 ELSE 0 END) AS id_exist,
    MAX(CASE WHEN UPPER(c.column_name) = 'REGION' THEN 1 ELSE 0 END) AS region_exist,
    MAX(CASE WHEN UPPER(c.column_name) = 'DESCRIPTION' THEN 1 ELSE 0 END) AS description_exist,
    MAX(CASE WHEN UPPER(c.column_name) = 'NAME' THEN 1 ELSE 0 END) AS name_exist 
FROM 
    INFORMATION_SCHEMA.TABLES t
LEFT JOIN 
    INFORMATION_SCHEMA.COLUMNS c ON t.table_name = c.table_name AND t.table_schema = c.table_schema
WHERE
    t.table_type = 'BASE TABLE' AND t.table_name ILIKE 'gcp_%s'
GROUP BY 
    t.table_name
HAVING
    MAX(CASE WHEN UPPER(c.column_name) = 'PROJECT_ID' THEN 1 ELSE 0 END)::boolean
    AND (MAX(CASE WHEN UPPER(c.column_name) = 'ID' THEN 1 ELSE 0 END)::boolean)

{% endmacro %} 

{% macro bigquery__gcp_tables_dyn() %}

SELECT 
    t.table_name,
    MAX(CASE WHEN UPPER(c.column_name) = 'PROJECT_ID' THEN 1 ELSE 0 END) AS project_id_exist,
    MAX(CASE WHEN UPPER(c.column_name) = 'ID' THEN 1 ELSE 0 END) AS id_exist,
    MAX(CASE WHEN UPPER(c.column_name) = 'REGION' THEN 1 ELSE 0 END) AS region_exist,
    MAX(CASE WHEN UPPER(c.column_name) = 'DESCRIPTION' THEN 1 ELSE 0 END) AS description_exist,
    MAX(CASE WHEN UPPER(c.column_name) = 'NAME' THEN 1 ELSE 0 END) AS name_exist  
FROM 
    {{ full_table_name("INFORMATION_SCHEMA.TABLES") }} t
INNER JOIN 
    {{ full_table_name("INFORMATION_SCHEMA.COLUMNS") }} c ON t.table_name = c.table_name AND t.table_schema = c.table_schema
WHERE
    t.table_type = 'BASE TABLE' AND t.table_name LIKE 'gcp_%s'
GROUP BY 
    t.table_name
HAVING
    MAX(CASE WHEN UPPER(c.column_name) = 'PROJECT_ID' THEN 1 ELSE 0 END)::bool
    AND (MAX(CASE WHEN UPPER(c.column_name) = 'ID' THEN 1 ELSE 0 END)::bool)

{% endmacro %}  