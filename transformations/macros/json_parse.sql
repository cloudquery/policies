{% macro json_parse(string, string_path) -%}

{{ adapter.dispatch('json_parse', 'cq_utils') (string, string_path) }}

{%- endmacro %}

{% macro default__json_parse(string, string_path) %}

  json_extract_path_text({{string}}, {%- for s in string_path -%}'{{ s }}'{%- if not loop.last -%},{%- endif -%}{%- endfor -%} )

{% endmacro %}

{% macro bigquery__json_parse(string, string_path) %}
 
  json_extract_scalar({{string}}, '$.{%- for s in string_path -%}{{ s }}{%- if not loop.last -%}.{%- endif -%}{%- endfor -%} ')

{% endmacro %}

{% macro postgres__json_parse(string, string_path) %}

  {{string}}::json #>> '{ {%- for s in string_path -%}{{ s }}{%- if not loop.last -%},{%- endif -%}{%- endfor -%} }'

{% endmacro %}

{% macro snowflake__json_parse(string, string_path) %}

  parse_json( {{string}} ) {%- for s in string_path -%}{% if s is number %}[{{ s }}]{% else %}['{{ s }}']{% endif %}{%- endfor -%}

{% endmacro %}
