---
# INSTALL PHP 8.0
# Install PHP 8.0 with extensions.  This list was created by finding the requirements for both Laravel and WordPress and
# and finding which extensions need to be additionally installed.  It's not expected for anything other than Laravel and
# WordPress to run on these machines, and even then it's likely this list is enough.
install_php:
  pkgrepo.managed:
    - ppa: ondrej/php
  pkg.latest:
    - pkgs:
      - php8.0
      - php8.0-bcmath
      - php8.0-cli
      - php8.0-curl
      - php8.0-fpm
      - php8.0-gd
      - php8.0-imagick
      - php8.0-intl
      - php8.0-mbstring
      - php8.0-mcrypt
      - php8.0-mysql
      - php8.0-ssh2
      - php8.0-xml
      - php8.0-zip
    - refresh: true
