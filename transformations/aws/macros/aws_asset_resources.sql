{% macro aws_asset_resources(table_name) %}

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

    /* This block was used when other views were evaluated.
    {% set cq_id_exists_query %}
        SELECT column_name
        FROM information_schema.columns
        WHERE table_name = '{{ table_name }}'
            AND column_name = '_cq_id'
    {% endset %}

    {% set cq_source_name_exists_query %}
        SELECT column_name
        FROM information_schema.columns
        WHERE table_name = '{{ table_name }}'
            AND column_name = '_cq_source_name'
    {% endset %}

    {% set cq_sync_time_exists_query %}
        SELECT column_name
        FROM information_schema.columns
        WHERE table_name = '{{ table_name }}'
            AND column_name = '_cq_sync_time'
    {% endset %}
    */ 

    SELECT
        /* TODO: Not sure why cq_id, cq_source_name, cq_sync_time aren't found in tables. 
        For now, putting in placeholders when those columns aren't found.  The previous implementation had SELECT _cq_id, _cq_source_name, _cq_sync_time without issues.

         {% if run_query(cq_id_exists_query).rows %}
            _cq_id
            {% else %}
            '11111111-1111-1111-1111-111111111111'
        {% endif %} AS _cq_id,

        {% if run_query(cq_source_name_exists_query).rows %}
           _cq_source_name
           {% else %}
           'Unknown'
        {% endif %} AS _cq_source_name,

        {% if run_query(cq_sync_time_exists_query).rows %}
            _cq_sync_time
            {% else %}
            '2000-01-01 00:00:00.000000'
        {% endif %} AS _cq_sync_time, 
        */
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