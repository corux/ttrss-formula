{% from "ttrss/map.jinja" import ttrss with context %}

include:
  - apache

ttrss-apache:
  file.managed:
    - name: /etc/httpd/conf.d/ttrss.conf
    - source: salt://ttrss/files/ttrss-apache.conf
    - template: jinja
    - defaults:
        config: {{ ttrss }}
    - watch_in:
      - module: apache-reload
