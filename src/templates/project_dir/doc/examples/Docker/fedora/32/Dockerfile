FROM fedora:32

RUN yum -y update && \
    yum -y install && \
    yum -y install \
        make \
        rpm-build \
        fakeroot

CMD /[% project.project_name %]/dist/Docker/fedora/32/build-dist.sh
