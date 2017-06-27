slurm_Reboot_Script:
  file.managed:
    - name: /usr/local/bin/rebootNode.sh
    - user: root
    - group: root
    - mode: '750'
    - source: salt://slurm/files/rebootNode.sh
