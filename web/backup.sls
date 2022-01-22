---
# DAILY BACKUP
# Create a compressed tarball daily of all the files and older in /srv/www.  The file will be stored on the mounted NFS
# drive.  The file will be called YYYY-MM-DD.tar.gz where Y represents the year, M the month and D the day.
daily_backup:
  cron.present:
    - name: tar -zcf "/mnt/ftpback-rbx2-173.ovh.net/$( hostname )/$( date '+%Y-%m-%d' ).tar.gz" /srv/www
    - user: root
    - special: '@daily'
    - require:
      - pkg: cron
