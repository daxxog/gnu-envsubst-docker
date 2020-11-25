FROM debian:buster
ARG GETTEXT_VERSION

# upgrade debian
RUN apt update
RUN DEBIAN_FRONTEND="noninteractive" apt install apt-utils -y
RUN DEBIAN_FRONTEND="noninteractive" apt upgrade -y

# install curl
RUN DEBIAN_FRONTEND="noninteractive" apt install curl -y

# install gettext dependencies
RUN DEBIAN_FRONTEND="noninteractive" apt install build-essential -y

# build and install gettext
WORKDIR /usr/src
RUN curl https://ftp.gnu.org/pub/gnu/gettext/gettext-$GETTEXT_VERSION.tar.gz | tar xzv
RUN cd gettext-$GETTEXT_VERSION && ./configure
RUN cd gettext-$GETTEXT_VERSION && make
RUN cd gettext-$GETTEXT_VERSION && make install
RUN rm -rf gettext-$GETTEXT_VERSION

WORKDIR /
CMD ["/usr/local/bin/envsubst"]
