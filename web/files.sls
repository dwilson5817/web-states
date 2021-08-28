---
# SECRETS DIRECTORY
# A directory with very tight permissions to store secrets.  At present there will only be one subdirectory created,
# certbot/ which will be used for storing Certbot secrets.
secrets_dir:
  file.directory:
    - name: /root/.secrets
    - user: root
    - group: root
    - dir_mode: 700
    - file_mode: 600

# CERTBOT DIRECTORY
# Secrets for Certbot, the autonomous TLS certificate deployment tool.  Permissions for this directory are similarly
# very tight because of the sensitive data being stored.
certbot_dir:
  file.directory:
    - name: /root/.secrets/certbot
    - user: root
    - group: root
    - dir_mode: 700
    - file_mode: 600
    - require:
      - file: secrets_dir

{%- set dns_credentials = salt['pillar.get']('letsencrypt:dns_credentials') %}
{%- set testing = salt['pillar.get']('testing') %}

# CLOUDFLARE SECRETS FILE
# CloudFlare API secrets for use by the Certbot CloudFlare DNS plugin.  At present, the package in the Ubuntu
# repositories is old and doesn't support the use of an API token.  When this is updated, the email and API key will not
# need to specified (only the API token).
cloudflare_ini:
  file.managed:
    - name: /root/.secrets/certbot/cloudflare.ini
    - user: root
    - group: root
    - mode: 600
    - require:
      - file: certbot_dir
    - template: jinja
    - contents: |
        # Cloudflare API credentials used by Certbot
        dns_cloudflare_email = {{ dns_credentials.email }}
        dns_cloudflare_api_key = {{ dns_credentials.api_key }}

        # # Cloudflare API token used by Certbot
        # dns_cloudflare_api_token = {{ dns_credentials.api_token }}

# SSL OPTIONS
# Nginx SSL options recommended by Let's Encrypt.  This file contains important security parameters including SSH
# session, protocol and cipher parameters.
nginx_ssl_options:
  file.managed:
    - name: /etc/letsencrypt/options-ssl-nginx.conf
    - source: https://raw.githubusercontent.com/certbot/certbot/master/certbot-nginx/certbot_nginx/_internal/tls_configs/options-ssl-nginx.conf
    - source_hash: 642ba50fd160e783ff33eed0bea6161f7826ca84a0fd38becbb18e527e9d68f2e5057c4a41814484711a08cec22249dbf2372b271d1306ea43e9f3234fd2b043
    - user: root
    - group: root
    - mode: 644

# SSL DIFFIE-HELLMAN PARAMETERS
# Nginx SSL DH parameters supplied by the Let's Encrypt project.  These parameters define how OpenSSL performs the
# Diffie-Hellman (DH) key-exchange.
nginx_ssl_dhparams:
  file.managed:
    - name: /etc/letsencrypt/ssl-dhparams.pem
    - source: https://raw.githubusercontent.com/certbot/certbot/master/certbot/certbot/ssl-dhparams.pem
    - source_hash: d701f16489970432057280130dcd11f7d623daa0f76cc78f7b74bb487706e6b5a013e410e29d7ba5b951b46dfbc661ff13ae90363f8cb4209b27d2eee339a7a2
    - user: root
    - group: root
    - mode: 644
