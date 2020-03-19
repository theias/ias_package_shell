FROM debian:9

RUN DEBIAN_FRONTEND=noninteractive apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get upgrade -y && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y -y \
        wget \
        build-essential \
        fakeroot

CMD /[% project.project_name %]/package_shell/dist/debian/9/build-dist.sh
