## Salt States: Web Formula

### Requirements

This formula requires the following additional formulas:

```yaml
    - name: letsencrypt
      repo: git
      source: https://gitlab.dylanwilson.dev/infrastructure/salt-formulas/letsencrypt-formula.git
    - name: nginx
      repo: git
      source: https://gitlab.dylanwilson.dev/infrastructure/salt-formulas/nginx-formula.git
    - name: php
      repo: git
      source: https://gitlab.dylanwilson.dev/infrastructure/salt-formulas/php-formula.git
```
