{%  if salt['pillar.get']('slurm:AuthType') == 'munge' %}
slurm_munge:
  pkg.installed:
    - name: {{ slurm.pkgMunge }}
  service:
    - running
    - name: munge
    - enable: True
    - watch:
      - file: /etc/munge/munge.key
    - require:
      - pkg: {{ slurm.pkgMunge }}
      - file: /etc/munge/munge.key

{%  if salt['pillar.get']('slurm:MungeKey64') is defined -%}
slurm_munge_key:
  file.managed:
    - name: /etc/munge/munge.key64
    - user: munge
    - group: munge
    - mode: '0400'
    - contents_pillar: slurm:MungeKey64
    - require:
        - pkg: slurm_munge
  cmd.wait:
    - name: base64 -d /etc/munge/munge.key64 >/etc/munge/munge.key
    - watch:
        - file: /etc/munge/munge.key64
  file.managed:
    - name: /etc/munge/munge.key
    - requre:
        - cmd: slurm_munge_key
    - replace: false
    - mode: '0400'
{%- else %}
slurm_munge_key:
  file.managed:
    - name: /etc/munge/munge.key
    - user: munge
    - group: munge
    - mode: 400
    - template: jinja
    - source: salt://slurm/files/munge.key
    - require:
      - pkg: slurm_munge
{% endif %}

## The default Ubuntu 16.04 version of munge breaks because of permissions
## on /var/log/.  We have to override this with --force at service startup
## time.  We need to install this before the package as the package
## tries to start itself.

{% if grains.os=='Ubuntu' and grains.osrelease=='16.04' %}
slurm_munge_service_config:
  file.managed:
    - name: /etc/systemd/system/munge.service
    - user: root
    - group: root
    - mode: '0644'
    - source: salt://slurm/files/munge.service
    - require_in:
        - pkg: slurm_munge
{% endif %}