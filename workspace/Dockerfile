# --------------------------------------------------------------------------
# Image Setup
# --------------------------------------------------------------------------

FROM phusion/baseimage:jammy-1.0.0

LABEL maintainer="Cerberos <development@cerberos.dev>"

# --------------------------------------------------------------------------
# Mandatory Software's Installation
# --------------------------------------------------------------------------

ENV DEBIAN_FRONTEND=noninteractive
ENV LANGUAGE=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8
ENV LC_CTYPE=en_US.UTF-8
ENV LANG=en_US.UTF-8
ENV TERM=xterm

RUN apt-get update -yqq && \
    apt-get install -y --no-install-recommends \
        build-essential \
        ca-certificates \
        curl \
        libedit-dev \
        libnghttp2-dev \
        libssl-dev \
        libxml2-dev \
        locales \
        nghttp2 \
        pkg-config \
        wget \
        xz-utils && \
    locale-gen en_US.UTF-8 && \
    update-locale LANG=en_US.UTF-8 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*


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
RUN if [ "${INSTALL_SSH}" = true ]; then \
    apt-get update -yqq && \
    apt-get install -y --no-install-recommends ssh && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
;fi

# --------------------------------------------------------------------------
# Cargo
# --------------------------------------------------------------------------

ARG INSTALL_CARGO=false
RUN if [ "${INSTALL_CARGO}" = true ]; then \
    apt-get update -yqq && \
    apt-get install -y --no-install-recommends gcc && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y \
;fi

# --------------------------------------------------------------------------
# Non-Root User: Add a non-root user to prevent files being created with root permissions on host machine.
# --------------------------------------------------------------------------

ARG PUID=1000
ARG PGID=1000

ENV PUID=${PUID}
ENV PGID=${PGID}

RUN groupadd -g ${PGID} crbdock && \
    useradd -u ${PUID} -g crbdock -m crbdock

# --------------------------------------------------------------------------
# Set Timezone
# --------------------------------------------------------------------------

ARG TZ=UTC
ENV TZ=${TZ}
RUN ln -snf /usr/share/zoneinfo/${TZ} /etc/localtime && echo ${TZ} > /etc/timezone

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

# Set default work directory
WORKDIR /var/www
