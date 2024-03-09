FROM almalinux:latest
ARG MYUSER=almalinux

USER root
RUN set -x; \
    yum check-update || true && \
    yum install -y which sudo git xz-libs wget unzip make gcc
RUN useradd ${MYUSER} -m -s /bin/bash && \
    echo "${MYUSER} ALL=(ALL:ALL) NOPASSWD: /usr/bin/su -" >>/etc/sudoers

COPY . /home/${MYUSER}/.dotfiles
RUN chown -R ${MYUSER}:${MYUSER} /home/${MYUSER}
USER ${MYUSER}
WORKDIR /home/${MYUSER}
RUN bash /home/${MYUSER}/.dotfiles/tests/user-build.sh
ENTRYPOINT bash
