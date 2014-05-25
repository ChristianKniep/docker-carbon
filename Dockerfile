###### compute node
# runs slurmd, sshd and is able to execute jobs via mpi
FROM qnib/terminal
MAINTAINER "Christian Kniep <christian@qnib.org>"

# carboniface
ADD yum-cache/carboniface /tmp/yum-cache/carboniface
RUN yum install -y python-docopt /tmp/yum-cache/carboniface/python-carboniface-1.0.3-1.x86_64.rpm
RUN rm -rf /tmp/yum-cache/carboniface

# carbon
RUN 	yum install -y python-carbon git-core
RUN     mkdir -p /var/lib/carbon/{whisper,lists}
RUN 	chown carbon -R /var/lib/carbon/whisper/
ADD     ./etc/init.d/carbon-cache /etc/init.d/
ADD     ./etc/supervisord.d/carbon.ini /etc/supervisord.d/

## Carbon config
ADD     ./etc/carbon/c0.conf /etc/carbon/
ADD     ./etc/carbon/storage-schemas.conf /etc/carbon/storage-schemas.conf

CMD /bin/supervisord -c /etc/supervisord.conf
