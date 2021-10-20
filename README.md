## Salt States: Web Formula

### Requirements

This formula requires the following additional formulas:

```yaml
    - name: core
      repo: git
      branch: main
      source: https://gitlab.dylanwilson.dev/infrastructure/salt-states/core-states.git
    - name: letsencrypt
      repo: git
      source: https://gitlab.dylanwilson.dev/infrastructure/salt-formulas/letsencrypt-formula.git
    - name: nginx
      repo: git
      source: https://gitlab.dylanwilson.dev/infrastructure/salt-formulas/nginx-formula.git
    - name: node
      repo: git
      source: https://gitlab.dylanwilson.dev/infrastructure/salt-formulas/node-formula.git
    - name: php
      repo: git
      source: https://gitlab.dylanwilson.dev/infrastructure/salt-formulas/php-formula.git
```
