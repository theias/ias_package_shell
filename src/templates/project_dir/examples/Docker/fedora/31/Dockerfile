FROM fedora:31

RUN yum -y update && \
    yum -y install \
        make \
        rpm-build \
        fakeroot

CMD /[% project.project_name %]/dist/Docker/fedora/31/build-dist.sh
