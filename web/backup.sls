---
# INSTALL CRON
# On live environments this will almost certainly be installed but when running inside a container the cron package is
# not pre-installed, so we include this state to ensure it is always available.
cron:
  pkg.installed

# DAILY BACKUP
# Create a compressed tarball daily of all the files and older in /srv/www.  The file will be stored on the mounted NFS
# drive.  The file will be called YYYY-MM-DD.tar.gz where Y represents the year, M the month and D the day.
daily_backup:
  cron.present:
    - name: tar -zcf "/mnt/ftpback-rbx2-173.ovh.net/$( hostname )/$( date '+\%Y-\%m-\%d' ).tar.gz" /srv/www
    - user: root
    - special: '@daily'
    - require:
      - pkg: cron

# HOURLY CLEANUP
# Every hour check of files older than 7 days in the backup location.  The find command will automatically delete them
# for us.  Find will look for files older than 6 days (i.e. at least 7 days old).
hourly_cleanup:
  cron.present:
    - name: find /mnt/ftpback-rbx2-173.ovh.net/"$( hostname )"/* -mtime +6 -type f -delete
    - user: root
    - special: '@hourly'
    - require:
      - pkg: cron
