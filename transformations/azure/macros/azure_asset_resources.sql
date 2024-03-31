{% macro azure_asset_resources(table_name) %}

    --Determine if Columns Exist for Table
    --`subscription_id`
    {% set subscription_id_exists_query %}
        SELECT column_name
        FROM information_schema.columns
        WHERE table_name = '{{ table_name }}'
            AND column_name = 'subscription_id'
    {% endset %}


    --`id`
    {% set id_exists_query %}
        SELECT column_name
        FROM information_schema.columns
        WHERE table_name = '{{ table_name }}'
            AND column_name = 'id'
    {% endset %}

    --location
    {% set location_exists_query %}
        SELECT column_name
        FROM information_schema.columns
        WHERE table_name = '{{ table_name }}'
            AND column_name = 'location'
    {% endset %}

    --kind
    {% set kind_exists_query %}
        SELECT column_name
        FROM information_schema.columns
        WHERE table_name = '{{ table_name }}'
            AND column_name = 'kind'
    {% endset %}
    
    --name
    {% set name_exists_query %}
        SELECT column_name
        FROM information_schema.columns
        WHERE table_name = '{{ table_name }}'
            AND column_name = 'name'
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
        _cq_id, 
        _cq_source_name, 
        _cq_sync_time,
        COALESCE(
           {% if run_query(subscription_id_exists_query).rows %}
                subscription_id
            {% else %}
                 'unavailable'
            {% endif %}
        ) AS subscription_id,
        COALESCE(
            {% if run_query(id_exists_query).rows %}
                reverse(split_part(reverse(id), '/'::TEXT, 1))
            {% else %}
                 'unavailable'
            {% endif %}
        ) AS id,
        {% if run_query(location_exists_query).rows %}
            location
            {% else %}
            'unavailable'
        {% endif %} AS location,
        {% if run_query(name_exists_query).rows %}
            name
            {% else %}
            NULL
        {% endif %} AS name, 
        {% if run_query(kind_exists_query).rows %}
            kind
            {% else %}
            NULL
        {% endif %} AS kind,
        '{{ table_name | string }}' AS _cq_table
    FROM {{ table_name | string }}

{% endmacro %}    

/*
COALESCE(
           {% if run_query(project_id_exists_query).rows %}
                project_id
            {% else %}
                 SPLIT_PART(self_link, '/', 7)
            {% endif %}
        ) AS account_id,

        COALESCE(
            {% if run_query(id_exists_query).rows %}
                id
            {% else %}
                 SPLIT_PART(arn, ':', 5)
            {% endif %}
        ) AS id, 

        split_part(self_link, '/', 8) AS TYPE,
        self_link,

        --TODO: Fix for some resources that may have regions (WAF Rule Group, aws_ec2_managed_prefix_lists)
        {% if run_query(region_exists_query).rows %}
            region
            {% else %}
            'unavailable'
        {% endif %} AS region,

        -- {% if run_query(tags_exists_query).rows %}
        --     tags
        -- {% else %}
        --     '{}'::jsonb
        -- {% endif %} AS tags,

        --SPLIT_PART(arn, ':', 2) AS PARTITION,
        SPLIT_PART(self_link, '/', 4) AS service,
*/