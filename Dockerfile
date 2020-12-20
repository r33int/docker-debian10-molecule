FROM debian:buster
LABEL maintainer="Jeroen Geusebroek"

RUN apt-get update && apt-get upgrade -y \
    && apt-get install -y --no-install-recommends \
       systemd \
       systemd-cron \
       python3.7 \
       ca-certificates \
       procps \
       sudo \
    && ln -s /usr/bin/python3.7 /usr/bin/python \
    && rm -Rf /var/lib/apt/lists/* \
    && rm -Rf /usr/share/doc && rm -Rf /usr/share/man \
    && apt-get clean \
    # Disable agetty, fixes zombie agetty 100% cpu.
    # https://github.com/moby/moby/issues/4040
    && cp /bin/true /sbin/agetty

COPY files/initctl_faker .
RUN chmod +x initctl_faker && rm -fr /sbin/initctl && ln -s /initctl_faker /sbin/initctl

RUN useradd -ms /bin/bash  ansible
RUN adduser ansible sudo
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

VOLUME [ "/sys/fs/cgroup" ]
CMD [ "/lib/systemd/systemd" ]
