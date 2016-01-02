#!/bin/bash

ret=0
function check_port {
    echo -n "Check 'nmap 127.0.0.1 -PN -p ${1} | grep open'... "
    nmap 127.0.0.1 -PN -p ${1} | grep open >/dev/null
    EC=$?
    if [ ${EC} -ne 0 ];then
        echo "[FAILED]"
        ret=$(( EC > ret ? EC : ret ))
    else
        echo "[OK]"
    fi
}

if [ "X${1}" != "X" ];then
    check_port ${1}
else
    for x in $(find /etc/carbon/*.conf);do 
        p=$(grep ^LINE_RECEIVER_PORT $x|egrep -o "[0-9]+")
        if [ "X${p}" != "X" ];then
            check_port $p
        fi
    done
fi
exit ${ret} 
