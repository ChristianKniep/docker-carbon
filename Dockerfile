###### compute node
# runs slurmd, sshd and is able to execute jobs via mpi
FROM qnib/terminal
MAINTAINER "Christian Kniep <christian@qnib.org>"

# carboniface
ADD yum-cache/carboniface /tmp/yum-cache/carboniface
RUN yum install -y python-docopt /tmp/yum-cache/carboniface/python-carboniface-1.0.3-1.x86_64.rpm
RUN rm -rf /tmp/yum-cache/carboniface

# remove pyopenssl from qnib/terminal
RUN yum erase -y python-pyopenssl

# carbon
RUN 	yum install -y python-carbon git-core
RUN     mkdir -p /var/lib/carbon/{whisper,lists}
RUN 	chown carbon -R /var/lib/carbon/whisper/
ADD     etc/supervisord.d/carbon.ini /etc/supervisord.d/

## Carbon config
ADD     ./etc/carbon/c0.conf /etc/carbon/
ADD     ./etc/carbon/storage-schemas.conf /etc/carbon/storage-schemas.conf

##### USER
# Set (very simple) password for root
RUN echo "root:root"|chpasswd
ADD root/ssh /root/.ssh
RUN chmod 600 /root/.ssh/authorized_keys
RUN chmod 600 /root/.ssh/id_rsa
RUN chmod 644 /root/.ssh/id_rsa.pub
RUN chown -R root:root /root/*

### SSHD
RUN yum install -y openssh-server
RUN mkdir -p /var/run/sshd
RUN sshd-keygen
RUN sed -i -e 's/#UseDNS yes/UseDNS no/' /etc/ssh/sshd_config
ADD etc/supervisord.d/sshd.ini /etc/supervisord.d/sshd.ini

VOLUME ["/var/lib/carbon/whisper"]
EXPOSE 2003
EXPOSE 2004
EXPOSE 7002
CMD /bin/supervisord -c /etc/supervisord.conf
