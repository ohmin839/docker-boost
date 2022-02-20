FROM ubuntu:focal

MAINTAINER ohmin839

ARG DEBIAN_FRONTEND=noninteractive
ARG DEBCONF_NOWARNINGS=yes

ARG BOOST_VERSION
ARG BOOST_VERSION_
ENV BOOST_VERSION=${BOOST_VERSION}
ENV BOOST_VERSION_=${BOOST_VERSION_}
ENV BOOST_ROOT=/usr/local

ARG TMP_DIR=/tmp/boost${BOOST_VERSION}
RUN test -d ${TMP_DIR} || mkdir -p ${TMP_DIR}
WORKDIR ${TMP_DIR}

RUN apt-get -qq update && apt-get install -q -y software-properties-common
RUN add-apt-repository ppa:ubuntu-toolchain-r/test -y
RUN apt-get -qq update && apt-get install -qy g++ gcc make vim git wget

RUN wget --max-redirect 3 https://boostorg.jfrog.io/artifactory/main/release/${BOOST_VERSION}/source/boost_${BOOST_VERSION_}.tar.gz
RUN tar zxf boost_${BOOST_VERSION_}.tar.gz -C ${TMP_DIR} --strip-components=1
RUN ${TMP_DIR}/bootstrap.sh --prefix=${BOOST_ROOT}
RUN ${TMP_DIR}/b2 install

RUN ldconfig
