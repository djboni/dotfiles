FROM ubuntu:latest

USER root
RUN set -x; \
    apt update && \
    DEBIAN_FRONTEND=noninteractive apt install -y git make cmake ninja-build gettext unzip curl && \
    useradd user -m -s /bin/bash

COPY . /home/user/.dotfiles
COPY tests/user-build.sh /home/user
RUN chown -R user:user /home/user

USER user
WORKDIR /home/user
RUN bash ./user-build.sh
ENTRYPOINT bash
