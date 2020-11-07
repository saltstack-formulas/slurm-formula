{% from "slurm/map.jinja" import slurm with context %}
{%- set  slurmConf = pillar.get('slurm', {}) %}

slurm_user:
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
  group.present:
    - name: slurm
    - members:
        - slurm

slurm_client:
  pkg.installed:
    - name: {{ slurm.pkgSlurm }}
    - pkgs:
      - {{ slurm.pkgSlurm }}
      {%  if salt['pillar.get']('slurm:AuthType') == 'munge' %}
      - {{ slurm.pkgSlurmMunge }}
      {% endif %}
      - {{ slurm.pkgSlurmPlugins }}
    - refresh: True

slurm_config_dir:
  file.directory:
    - name: {{slurm.etcdir}}
    - user: slurm
    - group: root
    - mode: '755'
    - context:
        slurm: {{ slurm }}
slurm_logdir:
  file.directory:
    - name: {{ slurm.logdir }}
    - user: slurm
    - group: root
    - mode: '755'
slurm_rundir:
  file.directory:
    - name: {{slurm.rundir}}
    - user: slurm
    - group: root
    - mode: '755'
    - context:
        slurm: {{ slurm }}
slurmd_dir:
  file.directory:
    - name: {{slurm.slurmddir}}
    - user: slurm
    - group: root
    - mode: '755'
    - context:
        slurm: {{ slurm }}
slurmctld_dir:
  file.directory:
    - name: {{slurm.slurmctlddir}}
    - user: slurm
    - group: root
    - mode: '755'
    - context:
        slurm: {{ slurm }}
slurm_plugin_dir:
  file.directory:
    - name: {{slurm.plugindir}}
    - user: slurm
    - group: root
    - mode: '755'
    - context:
        slurm: {{ slurm }}        

slurm_cgroups_config:
  file.managed:
    - name: {{ slurm.etcdir }}/cgroup.conf
    - user: slurm
    - group: root
    - mode: '644'
    - template: jinja
    - source: salt://slurm/files/cgroup.conf
    - context:
        slurm: {{ slurm }}

slurmd_config:
  file.managed:
    - name: {{ slurm.etcdir }}/slurm.conf
    - user: slurm
    - group: root
    - mode: '644'
    - template: jinja
    - source: salt://slurm/files/slurm.conf.jinja
    - context:
        slurm: {{ slurm }}

slurm_gres_conf:
  file.managed:
    - name: {{ slurm.etcdir }}/gres.conf
    - user: slurm
    - group: root
    - mode: '644'
    - template: jinja
    - source: salt://slurm/files/gres.conf
