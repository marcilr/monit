#!/bin/bash
# set-creds.sh
# Created Fri Aug  9 13:20:02 AKDT 2019
# Copyright (C) 2019 by Raymond E. Marcil <marcilr@gmail.com>
#
# Script to set remote credentials on a set of files
#
# INPUT:
#   ~/.hosts   List of hosts and credentails to run command on.
#
# Execute with:
# ./setcred "old" "new"
#
#   Where "old" is the value to replace with "new"
#
# NOTE: Found that script not as reliable as I'd like.
#       Often times out a few entries before last.
#
# Links
# =====
# SSH: Execute Remote Command or Script – Linux
# Posted on Tuesday December 27th, 2016by admin
# ShellHacks, Linux Hacks and Guides
# https://www.shellhacks.com/ssh-execute-remote-command-script-linux/
#

# =============
# Configuration
# =============
HOSTS=~/.hosts

# User to run remote commands as
USER=root

# Monit configuration file
MONITRC=/etc/monitrc


# ========
# Binaries
# ========
CAT=/bin/cat
CUT=/usr/bin/cut
GREP=/bin/grep
HOSTNAME=/bin/hostname
LS=/bin/ls
SSH=/usr/bin/ssh

#
# noninteractive ssh password provider
# used to pass credential to ssh
#
SSHPASS=/usr/bin/sshpass

#
# Loop over host list in ~/.hosts
# Skip lines beginning with "#"
#
${CAT} ${HOSTS} | ${GREP} -v "#" | while read LINE; do

  echo "${LINE}"

  # Extract host name and credential from line
  HOST=`echo ${LINE} | ${CUT} --delimiter=',' --fields=1`
  CRED=`echo ${LINE} | ${CUT} --delimiter=',' --fields=2`

  echo "HOST: ${HOST}"
  echo "CRED: ${CRED}"

  # Execute remote command
  #${SSH} ${USER}@${HOST} '${LS} -al ${MONITRC"'

  CMD="${SSHPASS} -p ${CRED} ${SSH} ${USER}@${HOST} ${HOSTNAME}"
  echo "Executing: ${CMD}"

  ${SSHPASS} -p ${CRED} ${SSH} ${USER}@${HOST} ${HOSTNAME} < /dev/null


done
