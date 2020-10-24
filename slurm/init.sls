{% from "slurm/map.jinja" import slurm with context %}
{%- set  slurmConf = pillar.get('slurm', {}) %}


slurm_client:
  pkg.installed:
    - name: {{ slurm.pkgSlurm }}
    - pkgs:
      - {{ slurm.pkgSlurm }}
      {%  if salt['pillar.get']('slurm:AuthType') == 'munge' %}
      - {{ slurm.pkgSlurmMuge }}
      {% endif %}
      - {{ slurm.pkgSlurmPlugins }}
    - refresh: True

slurm_config_dir:
  file.directory:
    - name: {{slurm.etcdir}}
    - user: slurm
    - group: root
    - mode: '644'
    - context:
        slurm: {{ slurm }}

slurm_cgroups_config:
  file.managed:
    - name: {{slurm.etcdir}}/cgroup.conf
    - user: slurm
    - group: root
    - mode: '644'
    - template: jinja
    - source: salt://slurm/files/cgroup.conf
    - context:
        slurm: {{ slurm }}
slurm_config:
  file.managed:
    - name: {{slurm.etcdir}}/{{ slurm.config }}
    - user: slurm
    - group: root
    - mode: '644'
    - template: jinja 
    - source: salt://slurm/files/slurm.conf
    - context:
        slurm: {{ slurm }}
  user.present:
    - name: slurm
{% if slurmConf.UserHomeDir is defined %}
    - home: {{ slurmConf.UserHomeDir }}
{% endif %}
{% if slurmConf.userUid is defined %}
    - uid: {{ slurmConf.UserUid }}
{% endif %}
{% if slurmConf.userGid is defined %}
    - gid: {{ slurmConf.UserGid }}
{% else %}
    - gid_from_name: True
{% endif %}
    - require_in:
        - pkg: slurm_client

#  user.present:
#    - name: slurm
#    - home: /localhome/slurm
#    - uid: 550
#    - gid: 510
#    - gid_from_name: True


slurm_gres_conf:
  file.managed:
    - name: {{ slurm.etcdir }}/gres.conf
    - user: slurm
    - group: root
    - mode: '644'
    - template: jinja
    - source: salt://slurm/files/gres.conf
slurm_logdir:
  file.directory:
    - name: {{ slurm.logdir }}
    - user: slurm
    - group: slurm
    - mode: '0755'
