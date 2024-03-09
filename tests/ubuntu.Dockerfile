FROM ubuntu:latest
ARG MYUSER=ubuntu

USER root
RUN set -x; \
    apt update && \
    DEBIAN_FRONTEND=noninteractive \
    apt install -y sudo git xz-utils curl wget unzip make gcc
RUN useradd ${MYUSER} -m -s /bin/bash && \
    echo "${MYUSER} ALL=(ALL:ALL) NOPASSWD: /usr/bin/su -" >>/etc/sudoers

COPY . /home/${MYUSER}/.dotfiles
RUN chown -R ${MYUSER}:${MYUSER} /home/${MYUSER}
USER ${MYUSER}
WORKDIR /home/${MYUSER}
RUN bash /home/${MYUSER}/.dotfiles/tests/user-build.sh
ENTRYPOINT bash
