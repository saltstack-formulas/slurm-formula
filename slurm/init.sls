{% from "slurm/map.jinja" import slurm with context %}

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
{% if slurm.user_create|default(False) == True %}
slurm_user:
  user.present:
    - name: slurm
{% if slurm.homedir is defined %}
    - home: {{ slurm.user_homedir }}
{% endif %}
{% if slurm.user_uid is defined %}
    - uid: {{ slurm.user_uid }}
{% endif %}
{% if slurm.user_gid is defined %}
    - gid: {{ slurm.user_gid }}
{% else %}
    - gid_from_name: True
{% endif %}
    - require_in:
        - pkg: slurm_client
        - file: slurm_topology
        - file: slurm_cgroup
        - file: slurm_config_energy
{% endif %}

#  user.present:
#    - name: slurm
#    - home: /localhome/slurm
#    - uid: 550
#    - gid: 510
#    - gid_from_name: True


slurm_gres_conf:
  file.managed:
    - name: {{ slurm.gres_config }}
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
