###### QNIBTerminal instance
FROM qnib/terminal

VOLUME "/var/lib/carbon/whisper/"
# carbon
RUN 	echo 2015-05-30 && yum clean all && \
        yum install -y python-carbon && \
        mkdir -p /var/lib/carbon/{whisper,lists} && \
    	chown carbon -R /var/lib/carbon/whisper/ && \
        rm -f /etc/carbon/* && \
        touch /etc/carbon/aggregation-rules.conf && \
        touch /etc/carbon/storage-aggregation.conf
ADD     etc/supervisord.d/ /etc/supervisord.d/

## Carbon config
ADD     ./etc/carbon/ /etc/carbon/

ADD etc/consul.d/carbon.json /etc/consul.d/

ADD opt/qnib/carbon/bin/start_relay.sh /opt/qnib/carbon/bin/
