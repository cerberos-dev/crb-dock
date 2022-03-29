# --------------------------------------------------------------------------
# Image Setup
# --------------------------------------------------------------------------

FROM phusion/baseimage:bionic-1.0.0

LABEL key="Cerberos <development@cerberos.dev>"

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
    apt-get install -y --allow-downgrades --allow-remove-essential \
        --allow-change-held-packages \
        wget \
        curl \
        build-essential \
        nghttp2 \
        libnghttp2-dev \
        libssl-dev \
        pkg-config \
        libedit-dev \
        libxml2-dev \
        xz-utils \
        libsqlite3-dev \
        sqlite3 \
        git \
        vim \
        nano \
    && apt-get clean


# --------------------------------------------------------------------------
# Optional Software's Installation
# --------------------------------------------------------------------------


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
