FROM debian:10

RUN DEBIAN_FRONTEND=noninteractive apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get upgrade -y && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y -y \
        wget \
        build-essential \
        fakeroot

CMD /[% project.project_name %]/package_shell/dist/debian/10/build-dist.sh
