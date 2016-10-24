#!/bin/bash

#if [ "${AUTHORIZED_KEYS}" != "**None**" ]; then
#    echo "=> Found authorized keys"
#    mkdir -p /root/.ssh
#    chmod 700 /root/.ssh
#    touch /root/.ssh/authorized_keys
#    chmod 600 /root/.ssh/authorized_keys
#    IFS=$'\n'
#    arr=$(echo ${AUTHORIZED_KEYS} | tr "," "\n")
#    for x in $arr
#    do
#        x=$(echo $x |sed -e 's/^ *//' -e 's/ *$//')
#        cat /root/.ssh/authorized_keys | grep "$x" >/dev/null 2>&1
#        if [ $? -ne 0 ]; then
#            echo "=> Adding public key to /root/.ssh/authorized_keys: $x"
#            echo "$x" >> /root/.ssh/authorized_keys
#        fi
#    done
#fi

#if [ ! -f /.root_pw_set ]; then
#        /set_root_pw.sh
#fi

# Populate the contents of the PV if the copy is not indicated as done
if [ ! -e /apps/opt/weblogic/endeca/.copy_done ]; then
    echo "Copying files to /apps/opt/weblogic/endeca/ for Persistent Storage..."
    echo "Please wait, it will take several minitues"
    chown -R endeca /apps/opt/weblogic/endeca
    su -c "cp -r /apps/opt/weblogic/endeca-install/* /apps/opt/weblogic/endeca/" endeca
    su -c "touch /apps/opt/weblogic/endeca/.copy_done" endeca
    echo "Finished Copying all files to the Persistent Storage"
else
    echo "Endeca files already copied."
fi

su -c "/apps/opt/weblogic/endeca/PlatformServices/11.1.0/tools/server/bin/startup.sh &" endeca
su -c "/apps/opt/weblogic/endeca/ToolsAndFrameworks/11.1.0/server/bin/startup.sh &" endeca
#chown -R endeca /apps/opt/weblogic/endeca

su -c "/apps/opt/weblogic/endeca/CAS/11.1.0/bin/cas-service.sh &" endeca
su -c "ping localhost" endeca

#exec /usr/sbin/sshd -D
