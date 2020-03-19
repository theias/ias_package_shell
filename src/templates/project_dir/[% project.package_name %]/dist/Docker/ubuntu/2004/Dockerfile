FROM debian:20.04

RUN DEBIAN_FRONTEND=noninteractive apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get upgrade -y && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y -y \
        wget \
        build-essential \
        fakeroot

CMD /[% project.project_name %]/package_shell/dist/ubuntu/2004/build-dist.sh
