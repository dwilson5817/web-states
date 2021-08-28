## Salt States: Web Formula

### Requirements

This formula requires the following additional formulas:

```yaml
    - name: docker
      repo: git
      source: https://gitlab.dylanwilson.dev/infrastructure/salt-formulas/docker-formula.git
    - name: letsencrypt
      repo: git
      source: https://gitlab.dylanwilson.dev/infrastructure/salt-formulas/letsencrypt-formula.git
    - name: nginx
      repo: git
      source: https://gitlab.dylanwilson.dev/infrastructure/salt-formulas/nginx-formula.git
```
