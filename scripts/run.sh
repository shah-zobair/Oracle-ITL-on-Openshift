#!/bin/bash

if [ "${AUTHORIZED_KEYS}" != "**None**" ]; then
    echo "=> Found authorized keys"
    mkdir -p /root/.ssh
    chmod 700 /root/.ssh
    touch /root/.ssh/authorized_keys
    chmod 600 /root/.ssh/authorized_keys
    IFS=$'\n'
    arr=$(echo ${AUTHORIZED_KEYS} | tr "," "\n")
    for x in $arr
    do
        x=$(echo $x |sed -e 's/^ *//' -e 's/ *$//')
        cat /root/.ssh/authorized_keys | grep "$x" >/dev/null 2>&1
        if [ $? -ne 0 ]; then
            echo "=> Adding public key to /root/.ssh/authorized_keys: $x"
            echo "$x" >> /root/.ssh/authorized_keys
        fi
    done
fi

if [ ! -f /.root_pw_set ]; then
        /set_root_pw.sh
fi

# Populate the contents of the PV if the copy is not indicated as done
if [ ! -e /apps/opt/weblogic/endeca/.copy_done ]; then
    echo "Copying files to /apps/opt/weblogic/endeca/"
    cp -r /apps/opt/weblogic/endeca-install/* /apps/opt/weblogic/endeca/
    touch /apps/opt/weblogic/endeca/.copy_done
else
    echo "Endeca files already copied."
fi

/apps/opt/weblogic/endeca/PlatformServices/11.1.0/tools/server/bin/startup.sh &
/apps/opt/weblogic/endeca/ToolsAndFrameworks/11.1.0/server/bin/startup.sh &
exec /usr/sbin/sshd -D
