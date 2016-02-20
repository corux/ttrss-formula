{% from "ttrss/map.jinja" import ttrss with context %}

policycoreutils-python:
  pkg.installed:
    - name: policycoreutils-python

{% for dir in [ '/cache', '/feed-icons', '/lock' ] %}
ttrss-selinux-{{ dir }}:
  cmd.run:
    - name: semanage fcontext -a -t httpd_sys_rw_content_t '{{ dir }}(/.*)?'
    - unless: semanage fcontext --list | grep '{{ dir }}(/.*)?' | grep httpd_sys_rw_content_t
    - require:
      - git: ttrss-git
    - watch_in:
      - module: ttrss-selinux-restorecon
{% endfor %}

ttrss-selinux-restorecon:
  module.wait:
    - name: file.restorecon
    - path: {{ ttrss.directory }}
    - recursive: True
    - watch:
      - git: ttrss-git
