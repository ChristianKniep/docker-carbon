###### compute node
# runs slurmd, sshd and is able to execute jobs via mpi
FROM qnib/terminal
MAINTAINER "Christian Kniep <christian@qnib.org>"

# remove pyopenssl from qnib/terminal
RUN yum erase -y python-pyopenssl

# carbon
RUN 	yum install -y python-carbon git-core
RUN     mkdir -p /var/lib/carbon/{whisper,lists}
RUN 	chown carbon -R /var/lib/carbon/whisper/
ADD     etc/supervisord.d/c0.ini /etc/supervisord.d/
ADD     etc/supervisord.d/c1.ini /etc/supervisord.d/
ADD     etc/supervisord.d/r0.ini /etc/supervisord.d/

## Carbon config
ADD     ./etc/carbon/c0.conf /etc/carbon/
ADD     ./etc/carbon/c1.conf /etc/carbon/
ADD     ./etc/carbon/r0.conf /etc/carbon/
ADD     ./etc/carbon/storage-schemas.conf /etc/carbon/storage-schemas.conf
RUN     touch /etc/carbon/aggregation-rules.conf
RUN     touch /etc/carbon/storage-aggregation.conf

EXPOSE 2003
EXPOSE 7002

CMD /bin/supervisord -c /etc/supervisord.conf
