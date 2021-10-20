---
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
{% for site, subdomains in pillar.get('sites', {}).items() %}

{%- set site_friendly = site | replace(".", "_")  %}

# GET LET'S ENCRYPT CERTIFICATE
# Use the Let's Encrypt CloudFlare plugin to get a TLS certificate.  When in testing, we use the Let's Encrypt staging
# server to confirm everything is correctly configured but prevent generating a real TLS certificate.
{{ site_friendly }}_cert:
  acme.cert:
    - name: {{ site }}
    - aliases:
      {% for subdomain in subdomains %}
      - {{ subdomain }}.{{ site }}
      {% endfor %}
    - email: webmaster@dylanw.net
    - dns_plugin: cloudflare
    - dns_plugin_credentials: /root/.secrets/certbot/cloudflare.ini
    {% if testing %}
    - server: https://acme-staging-v02.api.letsencrypt.org/directory
    {% endif %}
    - require:
      - file: cloudflare_ini

# CREATE SITE DIRECTORY
# Create a directory to store the site files.  This will contain directories to each of the subdomains for this site.
# For example, if this site is example.com, /srv/www/example.com will be created.
{{ site_friendly }}_dir:
  file.directory:
    - name: /srv/www/{{ site }}
    - user: dylan
    - group: dylan
    - require:
      - file: web_dir
      - user: user_dylan

{% for subdomain in subdomains %}

# CREATE SUBDOMAIN DIRECTORY
# For each subdomain, create a directory to store the subdomain files.  This will be within the site directory create
# above.  For example, if this site is example.com and this subdomain is www, /srv/www/example.com/www will be created.
{{ site_friendly }}_{{ subdomain }}_dir:
  file.directory:
    - name: /srv/www/{{ site }}/{{ subdomain }}
    - user: dylan
    - group: dylan
    - require:
      - file: {{ site_friendly }}_dir
      - user: user_dylan

{% endfor %}

{% endfor %}
