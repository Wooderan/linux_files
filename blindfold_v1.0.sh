#!/bin/bash
#
#
#    Bash script to make your system blind. It will setup your system
#    to shred all logs every minute and clear bash history after after logout.
#
#    Usage:
#       sudo bash blindfold.sh
#       srm blindfold.sh
#

CRONTAB_FILE="/etc/cron.d/blindfold"
OPENVPN_FILE="/etc/openvpn/server/server.conf"
OPENVPN_DIR="/etc/openvpn/server/"

# colors
RED="\033[0;31m"
GREEN="\033[1;32m"
YELLOW="\033[1;33m"
NC="\033[0m"



# function to exit script if last command executes with error
assert_error(){
    local EXITVALUE=$?
    if [ $EXITVALUE != 0 ]; then
        echo -e $RED"Error: "$1$NC
        exit $EXITVALUE
    fi
}

# check if run with superuser privileges
if [[ "$EUID" -ne 0 ]]; then
        echo -e $RED"Error: This tool needs to be run with superuser privileges."$NC
        exit
fi

echo -e "Installing secure-delete tool"
# install secure-delete tool to be able to shred off all logs
apt install -y secure-delete
assert_error "Can't install secure-delete tool"
echo -e $GREEN">>>DONE"$NC

echo -e "\nCreating crontable file"
# create cron table to execute logrotate every minute
{
    echo "* * * * * root srm -r /var/log"
} > $CRONTAB_FILE
assert_error "Can't create crontab $CRONTAB_FILE"
echo -e $GREEN">>>DONE"$NC

echo -e "\nRestarting cron deamon"
# restart cron deamon
systemctl restart cron
assert_error "Can't restart cron deamon"
echo -e $GREEN">>>DONE"$NC

echo -e "\nModifying journald.conf file to disable systemd-journal log"
# modify journald.conf file to disable journalctl log
if [[ "$(cat /etc/systemd/journald.conf)" != *"Storage=none"* ]]; then
    {
        echo "Storage=none"
    } >> /etc/systemd/journald.conf
    assert_error "Can't modify journald.conf"
    echo -e $GREEN">>>DONE"$NC
else
    echo -e $YELLOW"Info: journald.conf already modified"$NC
fi

echo -e "\nDeleting old systemd-journal logs"
# delete old journalctl log
if [ -d /var/log/journal ]; then
    srm -r /var/log/journal
    assert_error "Can't delete /var/log/journal"
    echo -e $GREEN">>>DONE"$NC
else
    echo -e $YELLOW"Info: There is no old systemd-journal logs"$NC
fi

echo -e "\nDisabling rsyslog.service"
#disable rsyslog service
systemctl stop rsyslog
assert_error "Can't stop rsyslog service"
systemctl disable rsyslog
assert_error "Can't disable rsyslog service"
echo -e $GREEN">>>DONE"$NC

echo -e "\nModifying root's .bash_logout file to clear history and logs"
# add commands to clear history and logs when root logout
if [[ "$(cat /root/.bash_logout)" != *"history -c && history -w"* ]]; then
    {
        echo "history -c && history -w"
        echo "/usr/sbin/logrotate $LOGROTATE_FILE"
    } >> /root/.bash_logout
    assert_error "Can't add commands to root .bash_logout file"
    echo -e $GREEN">>>DONE"$NC
else
    echo -e $YELLOW"Info: root's .bash_logout already modified"$NC
fi

echo -e "\nSearching all local users"
# searching all local users
local_users=($(eval getent passwd {$(awk '/^UID_MIN/ {print $2}' /etc/login.defs)..$(awk '/^UID_MAX/ {print $2}' /etc/login.defs)} | cut -d: -f1))
echo -e $GREEN">>>DONE"$NC

# add commands to clear history when users logout
for u in ${local_users[@]}; do
    echo -e "\nModifying $u's .bash_logout file to clear history"
    if [[ "$(cat /home/$u/.bash_logout)" != *"history -c && history -w"* ]]; then
        {
            echo "history -c && history -w"
        } >> /home/$u/.bash_logout
        assert_error "Can't add commands to $u .bash_logout file"
        echo -e $GREEN">>>DONE"$NC
    else
        echo -e $YELLOW"Info: $u's .bash_logout already modified"$NC
    fi
done

echo -e "\nRemoving status log from openvpn configuration"
#remove status log from openvpn sever configuration
if [ -f $OPENVPN_FILE ]; then
    if [[ "$(cat $OPENVPN_FILE)" == *"status"* ]]; then
        IFS=$'\r\n' GLOBIGNORE='*' command eval 'lines=($(cat $OPENVPN_FILE))'
        assert_error "Can't read openvpn configuration file $OPENVPN_FILE"
        echo "" > $OPENVPN_FILE
        for l in "${lines[@]}"; do
            if [[ "$l" == *"status"* ]]; then
                arr=($l)
                rm $OPENVPN_DIR${arr[1]}
                assert_error "Can't remove openvpn status log $OPENVPN_DIR${arr[1]}"
            else
                echo $l >> $OPENVPN_FILE
            fi
        done
        echo -e $GREEN">>>DONE"$NC
        echo -e "\nRestarting openvpn.service"
        systemctl restart openvpn
        assert_error "Can't restart openvpn.service"
        echo -e $GREEN">>>DONE"$NC
    else
        echo -e $YELLOW"Info: There is no status log in openvpn configuration"$NC
    fi
else
    echo -e $YELLOW"Warning: Can't find openvpn server configuration file"$NC
fi


echo -e "\n"$GREEN"All done! Your system is blind now."$NC
