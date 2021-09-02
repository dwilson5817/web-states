---
# INSTALL NPM
# Laravel Mix uses npm to compile assets.  Install the latest version of npm from the Ubuntu default repositories.  We
# probably don't need the latest version so no need to install it from the npm repository.
install_npm:
  pkg.installed:
    - pkgs:
      - nodejs
      - npm
