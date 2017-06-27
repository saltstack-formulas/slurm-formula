{% if salt['pillar.get']('slurm:TopologyPlugin') in ['tree','3d_torus'] -%}
slurm_topolgy:
  file.managed:
    - name: {{slurm.etcdir}}/topology.conf
    - user: slurm
    - group: root
    - mode: '0644'
    - template: jinja
    - source: salt://slurm/files/topology.conf
    - context:
        slurm: {{ slurm }}
    - require:
      - pkg: {{ slurm.pkgSlurm }}
{% endif %}