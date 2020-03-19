FROM debian:11

RUN DEBIAN_FRONTEND=noninteractive apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get upgrade -y && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y -y \
        wget \
        build-essential \
        fakeroot

CMD /[% project.project_name %]/dist/Docker/debian/11/build-dist.sh
