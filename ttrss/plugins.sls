{% from "ttrss/map.jinja" import ttrss with context %}

ttrss-plugins:
  file.directory:
    - name: {{ ttrss.plugins_directory }}
    - makedirs: True

{% for name, plugin in ttrss.get('plugins', {}).items() %}
{% if plugin.get('enabled', False) %}
ttrss-plugin-{{ name }}:
  git.latest:
    - name: {{ plugin.url }}
    - rev: {{ plugin.get('version', 'master') }}
    - target: {{ ttrss.plugins_directory }}/{{ name }}
    - force_reset: True

  file.symlink:
    - name: {{ ttrss.directory }}/plugins.local/{{ name }}
    - target: {{ ttrss.plugins_directory }}/{{ name }}{% if 'path' in plugin %}/{{ plugin.path }}{% endif %}
{% endif %}
{% endfor %}
