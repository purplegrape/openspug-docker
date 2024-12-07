FROM docker.io/almalinux/9-minimal as build-stage-1
WORKDIR /opt
ADD --chmod=644 requirements.txt /
RUN microdnf makecache ;\
    microdnf install -y epel-release; \
    microdnf install -y redis; \
    microdnf install -y --enablerepo=crb git-core zip gcc openldap-devel mariadb-devel msgpack-devel python3-devel python3-pip;\ 
    microdnf clean all
    RUN python3 -m venv /opt/py3 ;\
    . /opt/py3/bin/activate ;\
    pip3 install -U pip;\
    pip3 install -r /requirements.txt

RUN git clone -b 3.0 https://github.com/openspug/spug; zip -qr spug.zip spug

FROM docker.io/almalinux/9-minimal
ENV VIRTUAL_ENV=/opt/py3
ENV PATH=/opt/py3/bin:$PATH

COPY --from=build-stage-1 /usr/bin/redis-server /usr/bin/redis-server
COPY --from=build-stage-1 /usr/bin/redis-cli /usr/bin/redis-cli
COPY --from=build-stage-1 /opt/py3 /opt/py3
COPY --from=build-stage-1 /opt/spug.zip /opt/

RUN microdnf makecache ;\
    microdnf install -y epel-release; \
    microdnf install -y git-lfs busybox rsync nginx-core supervisor mariadb openldap ; \
    microdnf install -y unzip procps-ng glibc-langpack-zh;\
    microdnf clean all

RUN ln -sf /dev/stderr /var/log/nginx/error.log
RUN ln -sf /dev/stdout /var/log/nginx/access.log

ADD --chmod=755 entrypoint.sh /
ADD --chmod=644 requirements.txt /
ADD --chmod=644 supervisord.conf /etc/

WORKDIR /data
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/usr/bin/supervisord", "-n" ]
EXPOSE 80