FROM almalinux:latest

USER root
RUN set -x; \
    yum check-update || true && \
    yum install -y sudo which git make cmake gettext unzip gcc xz-libs && \
    useradd user -m -s /bin/bash && \
    echo "user ALL=(ALL:ALL) NOPASSWD: /usr/bin/su -" >>/etc/sudoers

COPY . /home/user/.dotfiles
RUN chown -R user:user /home/user
USER user
WORKDIR /home/user
RUN bash /home/user/.dotfiles/tests/user-build.sh
ENTRYPOINT bash
