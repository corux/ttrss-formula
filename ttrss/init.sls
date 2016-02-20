{% from "ttrss/map.jinja" import ttrss with context %}
{% from "selinux/map.jinja" import selinux with context %}

include:
  - epel
  - php.ng
  - php.ng.mbstring
  - php.ng.gd
  - php.ng.xml
  - php.ng.cli
  - php.ng.{{ ttrss.get('config', {}).get('DB_TYPE', 'pgsql')|lower }}
{% if selinux.enabled %}
  - .selinux
{% endif %}

ttrss-git:
  pkg.installed:
    - pkgs:
      - git

  git.latest:
    - name: {{ ttrss.url }}
    - rev: {{ ttrss.version }}
    - target: {{ ttrss.directory }}
    - require:
      - pkg: ttrss-git

ttrssd-graceful-down:
  service.dead:
    - name: ttrssd
    - require:
      - module: ttrssd
    - prereq:
      - git: ttrss-git

ttrssd:
  file.managed:
    - name: /etc/systemd/system/ttrssd.service
    - source: salt://ttrss/files/ttrssd.service
    - template: jinja
    - defaults:
        config: {{ ttrss }}

  module.wait:
    - name: service.systemctl_reload
    - watch:
      - file: ttrssd

  service.running:
    - name: ttrssd
    - enable: True
    - require:
      - git: ttrss-git
      - cmd: ttrss-config

ttrss-config:
  cmd.run:
    - name: cp {{ ttrss.config_file }}-dist {{ ttrss.config_file }}
    - onlyif: test ! -f {{ ttrss.config_file }} || test `grep CONFIG_VERSION {{ ttrss.config_file }}|awk 'match($0, /([0-9]*)\)/, a) {print a[1]}'` -ne `grep CONFIG_VERSION {{ ttrss.config_file }}-dist|awk 'match($0, /([0-9]*)\)/, a) {print a[1]}'`
    - require:
      - git: ttrss-git

{% for key, value in ttrss.get('config', {}).items() %}
ttrss-config-{{ key }}:
  file.replace:
    - name: {{ ttrss.config_file }}
    - pattern: ^\s*(//\s*)?define\('{{ key }}'[^\;]*;
    - repl: \tdefine('{{ key }}', {% if value is string %}'{{ value }}'{% else %}{{ value }}{% endif %});
    - append_if_not_found: True
    - require:
      - cmd: ttrss-config
    - watch_in:
      - service: ttrssd
{% endfor %}

{% for dir in [ 'cache', 'feed-icons', 'lock' ] %}
ttrss-chmod-{{ dir }}:
  file.directory:
    - name: {{ ttrss.directory }}/{{ dir }}
    - user: apache
    - group: apache
    - mode: 755
    - recurse:
      - user
      - group
    - require:
      - git: ttrss-git
    - require_in:
      - service: ttrssd
{% endfor %}
