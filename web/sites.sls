---
# ENSURE USER DYLAN EXISTS
# The dylan user should have been created when this machine was initially setup.  When running tests inside Docker, this
# user will not exist so we create it before starting.
user_dylan:
  user.present:
    - name: dylan
    - fullname: Dylan Wilson

# CREATE WEB DIRECTORY
# This is the directory which will store the files for each of the sites being hosted on this machine.  This needs to
# exist before we can begin cloning Git repositories.
web_dir:
  file.directory:
    - name: /srv/www
    - user: dylan
    - require:
      - user: user_dylan

{%- set testing = salt['pillar.get']('testing') %}
{% for site, args in pillar.get('sites', {}).items() %}

{%- set site_friendly = site | replace(".", "_")  %}

# GET LET'S ENCRYPT CERTIFICATE
# Use the Let's Encrypt CloudFlare plugin to get a TLS certificate.  When in testing, we use the Let's Encrypt staging
# server to confirm everything is correctly configured but prevent generating a real TLS certificate.
{{ site_friendly }}_cert:
  acme.cert:
    - name: {{ site }}
    - email: webmaster@dylanw.net
    - dns_plugin: cloudflare
    - dns_plugin_credentials: /root/.secrets/certbot/cloudflare.ini
    {% if testing %}
    - server: https://acme-staging-v02.api.letsencrypt.org/directory
    {% endif %}
    - require:
      - file: cloudflare_ini

# CLONE SITE REPOSITORY
# Clone Git repository with site files into web directory.  This should include a docker-compose.yml file in the root of
# the repository which will be used to bring up the Docker containers for this site.
{{ site_friendly }}_repo:
  git.latest:
    - name: {{ args.repo }}
    - target: /srv/www/{{ site_friendly }}
    - user: dylan
    - require:
      - user: user_dylan

{% if not testing %}
{% for secret, secret_args in args.secrets.items() %}

# COPY SECRET IN PLACE
# For each secret of this site, we will move it in place - importantly we use the Jinja template engine so we can
# replace Jinja with the actual secrets.  This still be done with the vault.read_secret module.  This won't work inside
# a Docker container because no Vault server will be available, so it will only be run in production.
{{ site_friendly }}_{{ secret }}:
  file.managed:
    - name: /srv/www/{{ site_friendly }}/{{ secret_args.to }}
    - source: /srv/www/{{ site_friendly }}/{{ secret_args.from }}
    - user: dylan
    - template: jinja
    - require:
      - git: {{ site_friendly }}_repo
      - user: user_dylan

{% endfor %}

# BRING UP SITE
# All the files are in place, we will now bring up the site.  Use the dockercomposeup Salt module to bring up the
# docker-compose.yml file.  Importantly, this may not work if docker-compose has just been installed and so the path has
# not been updated - this also won't work inside a Docker container, so it will only be run in production.
dockercompose.up:
  module.run:
      - path: /srv/www/{{ site_friendly }}

{% endif %}

{% endfor %}
