#
# Execute this from the top-level ReFrame source directory
#

#
# LMod versions prior to 8.2 emitted Python commands differently, so we use this
# Dockerfile to test the bindings of older versions
#


FROM ubuntu:20.04

ENV TZ=Europe/Zurich
ENV DEBIAN_FRONTEND=noninteractive
ENV _LMOD_VER=7.7

# ReFrame user
RUN useradd -ms /bin/bash rfmuser

# ReFrame requirements
RUN \
  apt-get -y update && \
  apt-get -y install ca-certificates && \
  update-ca-certificates && \
  apt-get -y install gcc && \
  apt-get -y install make && \
  apt-get -y install git && \
  apt-get -y install python3 python3-pip

# Required utilities
RUN apt-get -y install wget

# Install Lmod
RUN \
  apt-get -y install lua5.3 lua-bit32:amd64 lua-posix:amd64 lua-posix-dev liblua5.3-0:amd64 liblua5.3-dev:amd64 tcl tcl-dev tcl8.6 tcl8.6-dev:amd64 libtcl8.6:amd64 lua-filesystem:amd64 lua-filesystem-dev:amd64 && \
  wget -q https://github.com/TACC/Lmod/archive/${_LMOD_VER}.tar.gz -O lmod.tar.gz && \
  tar xzf lmod.tar.gz && \
  cd Lmod-${_LMOD_VER} && \
  ./configure && make install

ENV BASH_ENV=/usr/local/lmod/lmod/init/profile

USER rfmuser

# Install ReFrame from the current directory
COPY --chown=rfmuser . /home/rfmuser/reframe/

WORKDIR /home/rfmuser/reframe

RUN ./bootstrap.sh

CMD ["/bin/bash", "-c", "./test_reframe.py --rfm-user-config=ci-scripts/configs/lmod.py -v"]
