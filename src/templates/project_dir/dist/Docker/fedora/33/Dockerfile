FROM fedora:33

RUN yum -y update && \
    yum -y install && \
    yum -y install \
        make \
        rpm-build \
        fakeroot

CMD /[% project.project_name %]/dist/Docker/fedora/33/build-dist.sh
