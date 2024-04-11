{% macro aws_asset_resources(table_name) %}
  {{ return(adapter.dispatch('aws_asset_resources')(table_name)) }}
{% endmacro %}

{% macro postgres__aws_asset_resources(table_name) %}

    --Determine if Columns Exist for Table
    --`account_id`
    {% set account_id_exists_query %}
        SELECT column_name
        FROM information_schema.columns
        WHERE table_name = '{{ table_name }}'
            AND lower(column_name) = 'account_id'
    {% endset %}


    --`request_account_id`
    {% set request_account_id_exists_query %}
        SELECT column_name
        FROM information_schema.columns
        WHERE table_name = '{{ table_name }}'
            AND lower(column_name) = 'request_account_id'
    {% endset %}

    --region
    {% set region_exists_query %}
        SELECT column_name
        FROM information_schema.columns
        WHERE table_name = '{{ table_name }}'
            AND lower(column_name) = 'region'
    {% endset %}
    
    --tags
    {% set tags_exists_query %}
        SELECT column_name
        FROM information_schema.columns
        WHERE table_name = '{{ table_name }}'
            AND lower(column_name) = 'tags'
    {% endset %}

    SELECT

        _cq_id, _cq_source_name, _cq_sync_time,
    
         COALESCE(
           {% if run_query(account_id_exists_query).rows %}
                account_id
            {% else %}
                 SPLIT_PART(arn, ':', 5)
            {% endif %}
        ) AS account_id,

        COALESCE(
            {% if run_query(request_account_id_exists_query).rows %}
                request_account_id
            {% else %}
                 SPLIT_PART(arn, ':', 5)
            {% endif %}
        ) AS request_account_id, 

        CASE
            WHEN SPLIT_PART(SPLIT_PART(ARN, ':', 6), '/', 2) = '' AND SPLIT_PART(arn, ':', 7) = '' THEN NULL
            ELSE SPLIT_PART(SPLIT_PART(arn, ':', 6), '/', 1)
        END AS TYPE,
        arn,

        --TODO: Fix for some resources that may have regions (WAF Rule Group, aws_ec2_managed_prefix_lists)
        {% if run_query(region_exists_query).rows %}
            region
            {% else %}
            'unavailable'
        {% endif %} AS region,

        {% if run_query(tags_exists_query).rows %}
            tags
        {% else %}
            '{}'::jsonb
        {% endif %} AS tags,

        SPLIT_PART(arn, ':', 2) AS PARTITION,
        SPLIT_PART(arn, ':', 3) AS service,

        '{{ table_name | string }}' AS _cq_table
    FROM {{ table_name | string }}

{% endmacro %}    

{% macro snowflake__aws_asset_resources(table_name) %}

    --Determine if Columns Exist for Table
    --`account_id`
    {% set account_id_exists_query %}
        SELECT column_name
        FROM information_schema.columns
        WHERE table_name = '{{ table_name }}'
            AND lower(column_name) = 'account_id'
    {% endset %}


    --`request_account_id`
    {% set request_account_id_exists_query %}
        SELECT column_name
        FROM information_schema.columns
        WHERE table_name = '{{ table_name }}'
            AND lower(column_name) = 'request_account_id'
    {% endset %}

    --region
    {% set region_exists_query %}
        SELECT column_name
        FROM information_schema.columns
        WHERE table_name = '{{ table_name }}'
            AND lower(column_name) = 'region'
    {% endset %}
    
    --tags
    {% set tags_exists_query %}
        SELECT column_name
        FROM information_schema.columns
        WHERE table_name = '{{ table_name }}'
            AND lower(column_name) = 'tags'
    {% endset %}

    SELECT

        _cq_id, _cq_source_name, _cq_sync_time,
    
        
           {% if run_query(account_id_exists_query).rows %}
                account_id
            {% else %}
                 SPLIT_PART(arn, ':' 5)
            {% endif %}
        AS account_id,

        
            {% if run_query(request_account_id_exists_query).rows %}
                request_account_id
            {% else %}
                 SPLIT_PART(arn, ':', 5)
            {% endif %}
        AS request_account_id, 

        CASE
            WHEN SPLIT_PART(SPLIT_PART(ARN, ':', 6), '/', 2) = '' AND SPLIT_PART(arn, ':', 7) = '' THEN NULL
            ELSE SPLIT_PART(SPLIT_PART(arn, ':', 6), '/', 1)
        END AS TYPE,
        arn,

        --TODO: Fix for some resources that may have regions (WAF Rule Group, aws_ec2_managed_prefix_lists)
        {% if run_query(region_exists_query).rows %}
            region
            {% else %}
            'unavailable'
        {% endif %} AS region,

        {% if run_query(tags_exists_query).rows %}
            trim(tags::variant)
        {% else %}
            '{}'::variant
        {% endif %} AS tags,

        SPLIT_PART(arn, ':', 2) AS PARTITION,
        SPLIT_PART(arn, ':', 3) AS service,

        '{{ table_name | string }}' AS _cq_table
    FROM {{ table_name | string }}

{% endmacro %} 

{% macro bigquery__aws_asset_resources(table_name) %}

    --Determine if Columns Exist for Table
    --`account_id`
    {% set account_id_exists_query %}
        SELECT column_name
        FROM {{ full_table_name("INFORMATION_SCHEMA.COLUMNS") }}
        WHERE table_name = '{{ table_name }}'
            AND lower(column_name) = 'account_id'
    {% endset %}


    --`request_account_id`
    {% set request_account_id_exists_query %}
        SELECT column_name
        FROM {{ full_table_name("INFORMATION_SCHEMA.COLUMNS") }}
        WHERE table_name = '{{ table_name }}'
            AND lower(column_name) = 'request_account_id'
    {% endset %}

    --region
    {% set region_exists_query %}
        SELECT column_name
        FROM {{ full_table_name("INFORMATION_SCHEMA.COLUMNS") }}
        WHERE table_name = '{{ table_name }}'
            AND lower(column_name) = 'region'
    {% endset %}
    
    --tags
    {% set tags_exists_query %}
        SELECT column_name
        FROM {{ full_table_name("INFORMATION_SCHEMA.COLUMNS") }}
        WHERE table_name = '{{ table_name }}'
            AND lower(column_name) = 'tags'
    {% endset %}

    SELECT

        _cq_id, _cq_source_name, _cq_sync_time,
    
          {% if run_query(account_id_exists_query).rows %}
                account_id
            {% else %}
                 SPLIT(arn, ':')[5]
            {% endif %}
        AS account_id,

        
            {% if run_query(request_account_id_exists_query).rows %}
                request_account_id
            {% else %}
                 SPLIT(arn, ':')[5]
            {% endif %}
        AS request_account_id, 

        CASE
            WHEN SPLIT(SPLIT(ARN, ':')[6], '/')[2] = '' AND SPLIT(arn, ':')[7] = '' THEN NULL
            ELSE SPLIT(SPLIT(arn, ':')[6], '/')[1]
        END AS TYPE,
        arn,

        --TODO: Fix for some resources that may have regions (WAF Rule Group, aws_ec2_managed_prefix_lists)
        {% if run_query(region_exists_query).rows %}
            region
            {% else %}
            'unavailable'
        {% endif %} AS region,

        {% if run_query(tags_exists_query).rows %}
            TO_JSON_STRING(tags)
        {% else %}
            TO_JSON_STRING(STRUCT()) 
        {% endif %} AS tags,

        SPLIT(arn, ':')[2] AS PARTITIONS,
        SPLIT(arn, ':')[3] AS service,

        '{{ table_name | string }}' AS _cq_table
    FROM {{ full_table_name(table_name | string) }}

{% endmacro %}  