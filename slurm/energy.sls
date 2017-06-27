{% if salt['pillar.get']('slurm:AcctGatherEnergyType') in ['none','ipmi','ibmaem','cray','rapi'] -%}
slurm_config_energy:
  file.managed:
    - name: {{slurm.etcdir}}/acct_gather.conf
    - user: slurm
    - group: root
    - mode: 644
    - template: jinja
    - source: salt://slurm/files/acct_gather.conf
    - context:
        slurm: {{ slurm }}
    - require:
      - pkg: slurm_client
{% endif %}