#!/bin/bash

INST_NAME=r0
### Stop if supervisord stops service
MYPID=/var/run/carbon-relay_r0.pid

function stop () {
  echo "Kill '${INST_NAME}'"
  kill -9 ${MYPID}
}

trap stop_carbon SIGTERM
### \STOP

##### If CARBON_METRICS_ENTRY != false the carbon relay also propagates itself as entry.carbon.service.consul
if [ "X${CARBON_METRICS_ENTRY" != "Xfalse" ];then
     sed -i  -e 's/"tags":.*storage.*/"tags": [ "storage", "entry" ],/' /etc/consul.d/carbon.json
     consul reload
fi

/usr/bin/python /bin/carbon-relay --instance=${INST_NAME} --conf=/etc/carbon/${INST_NAME}.conf --pidfile=${MYPID} --debug start
