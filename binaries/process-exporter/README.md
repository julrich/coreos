# Creating a new binary for CoreOS 

Because this was running quite nicely for journalbeat, we re-use that logic for process_exporter.

Currently there is no direct way to build for CoreOS. One has to utilize one of the three (CentOS, Fedora, Debian) existing targets: https://github.com/mheese/journalbeat/tree/master/ci

## Detailed steps

Use the supplied Bash-Script, which utilizes Dockerfile found in this folder: 'util/update-process-exporter-binary.sh'

WARNING: This is currently not running, because we can't fetch the percona/process_exporter repo, because it doesn't exist anymore
