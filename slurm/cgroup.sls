{% if slurm.use_cgroup %}
slurm_cgroup::
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
{% endif %}