{% macro monitor_web_application_insights_configured(framework, check_id) %}
  {{ return(adapter.dispatch('monitor_web_application_insights_configured')(framework, check_id)) }}
{% endmacro %}

{% macro default__monitor_web_application_insights_configured(framework, check_id) %}{% endmacro %}

{% macro postgres__monitor_web_application_insights_configured(framework, check_id) %}
SELECT
    id                                                                       AS resource_id,
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'Ensure Application Insights are Configured (Automated)' AS title,
    subscription_id                                                          AS subscription_id,
    CASE
        WHEN id is null
        THEN 'fail'
        ELSE 'pass'
    END                                                                          AS status
FROM azure_applicationinsights_components 
where kind = 'web'
    
        
{% endmacro %}

{% macro snowflake__monitor_web_application_insights_configured(framework, check_id) %}
SELECT
    id                                                                       AS resource_id,
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'Ensure Application Insights are Configured (Automated)' AS title,
    subscription_id                                                          AS subscription_id,
    CASE
        WHEN id is null
        THEN 'fail'
        ELSE 'pass'
    END                                                                          AS status
FROM azure_applicationinsights_components 
where kind = 'web'
    
        
{% endmacro %}

{% macro bigquery__monitor_web_application_insights_configured(framework, check_id) %}
SELECT
    id                                                                       AS resource_id,
    '{{framework}}' As framework,
    '{{check_id}}' As check_id,
    'Ensure Application Insights are Configured (Automated)' AS title,
    subscription_id                                                          AS subscription_id,
    CASE
        WHEN id is null
        THEN 'fail'
        ELSE 'pass' 
        END                                                                         AS status
FROM {{ full_table_name("azure_applicationinsights_components") }} 
WHERE kind = 'web'
        
{% endmacro %}