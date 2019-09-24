#!/bin/sh

printf " =========================================\n"
printf " =========================================\n"
printf " ======== Teamspeak Server Alpine ========\n"
printf " =========================================\n"
printf " =========================================\n"
printf " == by github.com/qdm12 - Quentin McGaw ==\n\n"

exitOnError(){
  # $1 must be set to $?
  status=$1
  message=$2
  [ "$message" != "" ] || message="Error!"
  if [ $status != 0 ]; then
    printf "$message (status $status)\n"
    exit $status
  fi
}

test -r data
exitOnError $? "/teamspeak/data is not readable, please 'chown 1000 data && chmod 700 data' on your host"
test -w data
exitOnError $? "/teamspeak/data is not writable, please 'chown 1000 data && chmod 700 data' on your host"
test -x data
exitOnError $? "/teamspeak/data is not executable, please 'chown 1000 data && chmod 700 data' on your host"
# If data is mounted and nothing is there
[ -f data/ts3server.sqlitedb ] || touch data/ts3server.sqlitedb
[ -f data/query_ip_blacklist.txt ] || touch data/query_ip_blacklist.txt
[ -f data/query_ip_whitelist.txt ] || touch data/query_ip_whitelist.txt
test -r data/ts3server.sqlitedb
exitOnError $? "/teamspeak/data/ts3server.sqlitedb is not readable, please 'chown 1000 data/ts3server.sqlitedb && chmod 700 data/ts3server.sqlitedb' on your host"
test -w data/ts3server.sqlitedb
exitOnError $? "/teamspeak/data/ts3server.sqlitedb is not writable, please 'chown 1000 data/ts3server.sqlitedb && chmod 700 data/ts3server.sqlitedb' on your host"
test -x data/ts3server.sqlitedb
exitOnError $? "/teamspeak/data/ts3server.sqlitedb is not executable, please 'chown 1000 data/ts3server.sqlitedb && chmod 700 data/ts3server.sqlitedb' on your host"
test -r data/query_ip_blacklist.txt
exitOnError $? "/teamspeak/data/query_ip_blacklist.txt is not readable, please 'chown 1000 data/query_ip_blacklist.txt && chmod 400 data/query_ip_blacklist.txt' on your host"
test -r data/query_ip_whitelist.txt
exitOnError $? "/teamspeak/data/query_ip_whitelist.txt is not readable, please 'chown 1000 data/query_ip_whitelist.txt && chmod 400 data/query_ip_whitelist.txt' on your host"
test -w logs
exitOnError $? "/teamspeak/logs is not writable, please 'chown 1000 data/logs && chmod 300 data/logs' on your host"
test -x logs
exitOnError $? "/teamspeak/logs is not executable, please 'chown 1000 data/logs && chmod 300 data/logs' on your host"
ln -sf data/ts3server.sqlitedb ts3server.sqlitedb
exitOnError $? "Can't symlink /teamspeak/data/ts3server.sqlitedb to /teamspeak/ts3server.sqlitedb"
ln -sf data/query_ip_blacklist.txt query_ip_blacklist.txt
exitOnError $? "Can't symlink /teamspeak/data/query_ip_blacklist.txt to /teamspeak/query_ip_blacklist.txt"
ln -sf data/query_ip_whitelist.txt query_ip_whitelist.txt
exitOnError $? "Can't symlink /teamspeak/data/query_ip_whitelist.txt to /teamspeak/query_ip_whitelist.txt"
./ts3server "$@"
status=$?
printf "\n =========================================\n"
printf " Exit with status $status\n"
printf " =========================================\n"
