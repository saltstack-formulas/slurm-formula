{% from "slurm/map.jinja" import slurm with context %}
include:
  - slurm

{% if salt['pillar.get']('slurm:CheckpointType') == 'blcr' -%}
slrum_checkpoint_pkgs:
  pkg.installed:
    - pkgs:
      - slurm-blcr
      - blcr
{% endif %}
