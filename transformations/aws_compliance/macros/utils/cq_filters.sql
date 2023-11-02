{% macro cq_filters() %}
  {{ return(adapter.dispatch('cq_filters')()) }}
{% endmacro %}



{% macro default__cq_filters() %}

where "_cq_sync_time" BETWEEN '{{var("_cq_sync_time_min", "1970-01-01 00:00:00+00")}}' AND '{{var("_cq_sync_time_max", modules.datetime.datetime.now() )}}'

AND "_cq_source_name" LIKE ANY ('{{var("_cq_source_name", "{%}")}}')

{% endmacro %}
