{% macro sql_va_send_scan_report_enabled_on_sql_server(framework, check_id) %}
  {{ return(adapter.dispatch('sql_va_send_scan_report_enabled_on_sql_server')(framework, check_id)) }}
{% endmacro %}

{% macro default__sql_va_send_scan_report_enabled_on_sql_server(framework, check_id) %}{% endmacro %}

{% macro postgres__sql_va_send_scan_report_enabled_on_sql_server(framework, check_id) %}
WITH vulnerability_emails AS (
    SELECT
        _cq_parent_id,
        UNNEST(
            CASE
                WHEN v.properties->'recurringScans'->'emails' IS NULL THEN ARRAY[NULL::text]
                WHEN jsonb_typeof(v.properties->'recurringScans'->'emails') <> 'array' THEN ARRAY[NULL::text]
                WHEN jsonb_array_length(v.properties->'recurringScans'->'emails') = 0 THEN ARRAY[NULL::text]
                ELSE ARRAY(
                    SELECT jsonb_array_elements_text(v.properties->'recurringScans'->'emails')
                )
            END
        ) AS emails
    FROM azure_sql_server_vulnerability_assessments v
),
emails_count AS (
    SELECT
        _cq_parent_id,
        COUNT(emails) AS emails_number
    FROM vulnerability_emails
    GROUP BY _cq_parent_id
)
SELECT
  s.id AS server_id,
  'cis_v1.3.0' AS framework,
  '4.2.4' AS check_id,
  'Ensure that VA setting Send scan reports to is configured for a SQL server (Automated)' AS title,
  s.subscription_id,
  CASE
    WHEN c.emails_number = 0 OR c.emails_number IS NULL
      THEN 'fail'
    ELSE 'pass'
  END AS result
FROM azure_sql_servers s
LEFT JOIN emails_count c ON
    s._cq_id = c._cq_parent_id
{% endmacro %}

{% macro snowflake__sql_va_send_scan_report_enabled_on_sql_server(framework, check_id) %}
WITH vulnerability_emails AS (
       SELECT
    id,
    email.value AS emails
FROM
    azure_sql_server_vulnerability_assessments v,
    LATERAL FLATTEN(input => v.properties:recurringScans:emails) AS email
),
emails_count AS (
    SELECT
        id,
        count(emails) AS emails_number
    FROM vulnerability_emails
    GROUP BY id
)
SELECT
  s.id AS server_id,
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'Ensure that VA setting Send scan reports to is configured for a SQL server (Automated)' as title,
  s.subscription_id,
  case
    when c.emails_number = 0 OR c.emails_number IS NULL
      then 'fail' else 'pass'
  end
FROM azure_sql_servers s
    LEFT JOIN azure_sql_server_vulnerability_assessments sv ON
        s._cq_id = sv._cq_parent_id
    LEFT JOIN emails_count c ON
        sv.id = c.id
{% endmacro %}

{% macro bigquery__sql_va_send_scan_report_enabled_on_sql_server(framework, check_id) %}
WITH vulnerability_emails AS (
       SELECT
    id,
    email AS emails
FROM
    {{ full_table_name("azure_sql_server_vulnerability_assessments") }} v,
    UNNEST(JSON_QUERY_ARRAY(v.properties.recurringScans.emails)) AS email
),
emails_count AS (
    SELECT
        id,
        count(emails) AS emails_number
    FROM vulnerability_emails
    GROUP BY id
)
SELECT
  s.id AS server_id,
  '{{framework}}' As framework,
  '{{check_id}}' As check_id,
  'Ensure that VA setting Send scan reports to is configured for a SQL server (Automated)' as title,
  s.subscription_id,
  case
    when c.emails_number = 0 OR c.emails_number IS NULL
      then 'fail' else 'pass'
  end
FROM {{ full_table_name("azure_sql_servers") }} s
    LEFT JOIN {{ full_table_name("azure_sql_server_vulnerability_assessments") }} sv ON
        s._cq_id = sv._cq_parent_id
    LEFT JOIN emails_count c ON
        sv.id = c.id
{% endmacro %}