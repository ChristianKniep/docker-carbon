###### QNIBTerminal Image
FROM qnib/terminal:sensu

RUN echo "2015-11-11.1" && \
    pip install carbon \
        whisper
RUN mkdir -p /var/lib/carbon/{whisper,lists} /etc/carbon/ && \
    touch /etc/carbon/aggregation-rules.conf && \
    touch /etc/carbon/storage-aggregation.conf
VOLUME "/var/lib/carbon/whisper/"
ADD etc/supervisord.d/ /etc/supervisord.d/

## Carbon config
ADD     ./etc/carbon/ /etc/carbon/

ADD etc/consul.d/carbon.json /etc/consul.d/
ADD opt/qnib/carbon/bin/start.sh /opt/qnib/carbon/bin/
## Generic check script
ADD opt/qnib/carbon/bin/check.sh /opt/qnib/carbon/bin/
## Sensu config
ADD etc/sensu/conf.d/carbon.json /etc/sensu/conf.d/
