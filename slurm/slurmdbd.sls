{% from "slurm/map.jinja" import slurm with context %}
include:
  - slurm

minion:
  pkg.installed:
    - name: {{ slurm.pkgMySQLpython }}
    - pkgs:
      - {{ slurm.pkgMySQLpython }}
  file.managed:
    - name: /etc/salt/minion.d/database.conf 
    - source: salt://slurm/files/database.conf
    - replace: True
    - mode: '0644'
  service.running:
    - name: salt-minion
    - enable: True
    - reload: True
    - watch:
      - file: /etc/salt/minion.d/database.conf
      
      
slurmdbd_mysql:
  pkg.installed:
   - name: {{ slurm.pkgMysqlSever }}
   - pkgs:
      - {{ slurm.pkgMysqlSever }}
  service.running:
    - name: {{ slurm.srvMysqlSever }}
    - enable: True
    - reload: True
  mysql_database.present:
    - name: slurm_acct_db
  mysql_user.present:
    - name: {{ salt['pillar.get']('slurm:AccountingStorageUser','slurm') }}
    - host: {{ salt['pillar.get']('slurm:AccountingStorageHost','localhost') }}
    - password: {{ salt['pillar.get']('slurm:AccountingStoragePass','slurm') }}
    - connection_user: root
    - connection_charset: utf8
    - saltenv:
      - LC_ALL: "en_US.utf8"
  mysql_grants.present:
    - name: slurm_acct_db_grant
    - grant: all privileges
    - database: slurm_acct_db.*
    - user: {{ salt['pillar.get']('slurm:AccountingStorageUser','slurm') }}
    - host: 'localhost'
    - watch:
      - mysql_database: slurm_acct_db
    - requiere: 
      - mysql_database: slurm_acct_db

slurm_slurmdbd_config:
  file.managed:
    - name: {{slurm.etcdir}}/slurmdbd.conf
    - user: root
    - group: root
    - mode: '644'
    - replace: True
    - template: jinja 
    - source: salt://slurm/files/slurmdbd.conf
    - context:
        slurm: {{ slurm }}

Bug_rpm_no_create_default_environment_slurmdbd:
  file.touch:
    - name: /etc/default/slurmdbd
    - onlyif:  'test ! -e /etc/default/slurmdbd'
    - require:
      - pkg: slurm_slurmdbd
    - require_in:
      - service: slurm_slurmdbd


slurmdbd:
  pkg.installed:
    - name: {{ slurm.pkgSlurmDBD }}
    - pkgs:
      - {{ slurm.pkgSlurmSQL }}
      - {{ slurm.pkgSlurmDBD }}
  service:
    - running
    - enable: true
    - reload: True
    - name: slurmdbd
    - watch:
      - file: /etc/slurm/slurmdbd.conf
    - require:
      - pkg: {{ slurm.pkgSlurmDBD }}
      {%  if salt['pillar.get']('slurm:AuthType') == 'munge' %}
      - service: munge
      {%endif %}
      - file: /etc/slurm/slurmdbd.conf
      - mysql_user: {{ salt['pillar.get']('slurm:AccountingStorageUser','slurm') }}
      - mysql_database: slurm_acct_db
      - file: Bug_rpm_no_create_default_environment_slurmdbd
  cmd.run:
    - name: /usr/bin/sacctmgr -i add cluster "{{ salt['pillar.get']('slurm:ClusterName','slurm') }}"
    - unless: sacctmgr show Cluster |grep -i "{{ salt['pillar.get']('slurm:ClusterName','slurm') }}"
  file.touch:
    - name: /etc/default/slurmdbd
    - onlyif:
       - file: exist_default_slurmdb
  
slurmdbd_config_logrotate_slurmdbd:
  file.managed:
    - name: /etc/logrotate.d/slurmdbd
    - user: root
    - group: root
    - mode: '644'
    - template: jinja
    - source: salt://slurm/files/slurmdbd-logrotate.log