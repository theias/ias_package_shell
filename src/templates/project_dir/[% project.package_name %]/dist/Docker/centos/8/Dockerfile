FROM centos:8

# Maybe we don't need PowerTools
#    yum-config-manager --enable --set-enabled PowerTools && \

RUN yum -y update && \
    yum -y install dnf-plugins-core && \
    yum -y install \
        make \
        rpm-build \
        fakeroot

CMD /[% project.project_name %]/package_shell/dist/centos/8/build-dist.sh
