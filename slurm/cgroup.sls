{% from "slurm/map.jinja" import slurm with context %}
#only if cgrups is active on pillars it is deffined
{% if  salt['pillar.get']('slurm:UseCgroup','False') == True %}
slurm_cgroup:
  file.managed:
    - name: {{slurm.etcdir}}/cgroup.conf
    - user: slurm
    - group: root
    - mode: 400
    - template: jinja
    - source: salt://slurm/files/cgroup.conf
    - context:
        slurm: {{ slurm }}
    - require_in:
      - service: slurm_node
    - require:
      - user: slurm
{% endif %}