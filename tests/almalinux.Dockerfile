FROM almalinux:latest

USER root
RUN set -x;\
    yum check-update || true &&\
    yum install -y which git make cmake gettext unzip gcc &&\
    useradd user -m -s /bin/bash

COPY . /home/user/.dotfiles
COPY tests/user-build.sh /home/user
RUN chown -R user:user /home/user

USER user
WORKDIR /home/user
RUN bash ./user-build.sh
ENTRYPOINT bash
