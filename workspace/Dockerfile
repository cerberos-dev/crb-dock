# --------------------------------------------------------------------------
# Image Setup
# --------------------------------------------------------------------------

FROM phusion/baseimage:jammy-1.0.0

LABEL maintainer="Cerberos <development@cerberos.dev>"

# --------------------------------------------------------------------------
# Mandatory Software's Installation
# --------------------------------------------------------------------------

RUN DEBIAN_FRONTEND=noninteractive
RUN locale-gen en_US.UTF-8

ENV LANGUAGE=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8
ENV LC_CTYPE=en_US.UTF-8
ENV LANG=en_US.UTF-8
ENV TERM xterm

RUN apt-get update && \
    apt-get install -y \
        --allow-downgrades \
        --allow-remove-essential \
        --allow-change-held-packages \
        build-essential \
        curl \
        libedit-dev \
        libnghttp2-dev \
        libssl-dev \
        libxml2-dev \
        nghttp2 \
        pkg-config \
        wget \
        xz-utils


# --------------------------------------------------------------------------
# Optional Software's Installation
#
# Optional Software's will only be installed if you set them to `true`
# in the `docker-compose.yml` before the build.
# --------------------------------------------------------------------------


# --------------------------------------------------------------------------
# SSH
# --------------------------------------------------------------------------

ARG INSTALL_SSH=false
RUN if [ ${INSTALL_SSH} = true ]; then \
    apt-get update && \
    apt-get install -y ssh \
;fi

# --------------------------------------------------------------------------
# Cargo
# --------------------------------------------------------------------------

ARG INSTALL_CARGO=false
RUN if [ ${INSTALL_CARGO} = true ]; then \
    curl https://sh.rustup.rs -sSf | sh -s -- -y \
;fi

# --------------------------------------------------------------------------
# Non-Root User: Add a non-root user to prevent files being created with root permissions on host machine.
# --------------------------------------------------------------------------

ARG PUID=1000
ARG PGID=1000

ENV PUID ${PUID}
ENV PGID ${PGID}

RUN groupadd -g ${PGID} crbdock && \
    useradd -u ${PUID} -g crbdock -m crbdock && \
    apt-get update -yqq

# --------------------------------------------------------------------------
# Set Timezone
# --------------------------------------------------------------------------

ARG TZ=UTC
ENV TZ ${TZ}
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# --------------------------------------------------------------------------
# Crontab
# --------------------------------------------------------------------------

USER root

COPY ./crontab /etc/cron.d
RUN chmod -R 644 /etc/cron.d

# --------------------------------------------------------------------------
# User Aliases
# --------------------------------------------------------------------------

USER crbdock
COPY ./aliases.sh /home/crbdock/aliases.sh
RUN echo "" >> ~/.bashrc && \
    echo "# Load Custom Aliases" >> ~/.bashrc && \
    echo "source /home/crbdock/aliases.sh" >> ~/.bashrc && \
    echo "" >> ~/.bashrc && \
    sed -i 's/\r//' /home/crbdock/aliases.sh && \
    sed -i 's/^#! \/bin\/sh/#! \/bin\/bash/' /home/crbdock/aliases.sh

USER root
RUN echo "" >> ~/.bashrc && \
    echo "# Load Custom Aliases" >> ~/.bashrc && \
    echo "source /home/crbdock/aliases.sh" >> ~/.bashrc && \
    echo "" >> ~/.bashrc && \
    sed -i 's/\r//' /home/crbdock/aliases.sh && \
    sed -i 's/^#! \/bin\/sh/#! \/bin\/bash/' /home/crbdock/aliases.sh

# --------------------------------------------------------------------------
# Final Touch
# --------------------------------------------------------------------------

# Clean up
USER root
RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Set default work directory
WORKDIR /var/www
