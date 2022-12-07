#!/usr/bin/env bash

set -o pipefail  # trace ERR through pipes
set -o errtrace  # trace ERR through 'time command' and other functions
set -o nounset   ## set -u : exit the script if you try to use an uninitialised variable
set -o errexit   ## set -e : exit the script if any statement returns a non-true return value
# set -x # Uncomment for debugging

ssh -t "momcorphq" \
  "sudo rm -rf /tmp/backups/atlassian; \
  sudo mkdir -p /tmp/backups/atlassian; \
  sudo chmod a+w /tmp/backups/atlassian; \
  sudo docker run -t --rm postgres pg_dump -h postgres.services.ruhmesmeile.local -U postgres jira > \"/tmp/backups/atlassian/$(date +%Y%m%d)-pgbackup-jira.sql\"; \
  sudo docker run -t --rm postgres pg_dump -h postgres.services.ruhmesmeile.local -U postgres confluence > \"/tmp/backups/atlassian/$(date +%Y%m%d)-pgbackup-confluence.sql\"; \
  sudo docker run -t --rm postgres pg_dump -h postgres.services.ruhmesmeile.local -U postgres bitbucket > \"/tmp/backups/atlassian/$(date +%Y%m%d)-pgbackup-bitbucket.sql\"; \
  sudo docker run -t --rm postgres pg_dump -h postgres.services.ruhmesmeile.local -U postgres bamboo > \"/tmp/backups/atlassian/$(date +%Y%m%d)-pgbackup-bamboo.sql\";
  sudo docker run -t --rm postgres pg_dump -h postgres.services.ruhmesmeile.local -U postgres crowd > \"/tmp/backups/atlassian/$(date +%Y%m%d)-pgbackup-crowd.sql\";
  sudo mkdir -p /mnt/atlassian/backup/atlassian; \
  sudo rm -rf \"/mnt/atlassian/backup/$(date +%Y%m%d)-pgbackup-*\"
  sudo cp \"/tmp/backups/atlassian/$(date +%Y%m%d)-pgbackup-\"* /mnt/atlassian/backup/; \
  sudo rsync -avzP --delete /var/atlassian/jira/ /mnt/atlassian/backup/atlassian/jira/; \
  sudo rsync -avzP --delete /var/atlassian/confluence/ /mnt/atlassian/backup/atlassian/confluence/; \
  sudo rsync -avzP --delete /var/atlassian/bitbucket/ /mnt/atlassian/backup/atlassian/bitbucket/; \
  sudo rsync -avzP --delete /var/atlassian/crowd/ /mnt/atlassian/backup/atlassian/crowd/;"

ssh -t "momcorpdoop" \
  "sudo mkdir -p /var/bamboo/backup/atlassian/bamboo/ && sudo rsync -avzP --delete /var/atlassian/bamboo/ /var/bamboo/backup/atlassian/bamboo/; \
  sudo mkdir -p /var/bamboo/backup/atlassian/bamboo-nfs/ && sudo rsync -avzP --delete --exclude='/backup' /var/bamboo/ /var/bamboo/backup/atlassian/bamboo-nfs/;"
