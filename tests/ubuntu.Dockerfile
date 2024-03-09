FROM ubuntu:latest

USER root
RUN set -x; \
    apt update && \
    DEBIAN_FRONTEND=noninteractive apt install -y sudo git make cmake ninja-build gettext unzip curl xz-utils && \
    useradd user -m -s /bin/bash && \
    echo "user ALL=(ALL:ALL) NOPASSWD: /usr/bin/su -" >>/etc/sudoers

COPY . /home/user/.dotfiles
RUN chown -R user:user /home/user
USER user
WORKDIR /home/user
RUN bash /home/user/.dotfiles/tests/user-build.sh
ENTRYPOINT bash
