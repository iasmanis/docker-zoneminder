FROM ubuntu:18.04

LABEL maintainer="Ingemars Asmanis"

ENV DEBIAN_FRONTEND=noninteractive
ENV ZM_VERSION=1.34.25-bionic1

# Source for packages 
# https://launchpad.net/~iconnor/+archive/ubuntu/zoneminder-1.34
RUN echo "# Update base packages" \
    && apt update \
    && apt upgrade --assume-yes \
    && echo "# Install pre-reqs" \
    && apt install --assume-yes --no-install-recommends gnupg curl \
    && echo "# Configure Zoneminder PPA" \
    && apt-key adv --keyserver keyserver.ubuntu.com --recv-keys ABE4C7F993453843F0AEB8154D0BF748776FFB04 \
    && echo deb http://ppa.launchpad.net/iconnor/zoneminder-1.34/ubuntu bionic main > /etc/apt/sources.list.d/zoneminder.list \
    && apt update \
    && echo "# Install zoneminder" \
    && apt install --assume-yes zoneminder=$ZM_VERSION \
    && a2enconf zoneminder \
    && a2enmod rewrite cgi \
    && sed -i -e "s/error_reporting =.*/error_reporting = E_ALL \& ~E_NOTICE \& ~E_STRICT \& ~E_DEPRECATED/g" /etc/php/7.2/apache2/php.ini \
    && rm -r /var/lib/apt/lists/*

HEALTHCHECK --interval=15s --timeout=10s --retries=3 \
    CMD ["curl", "--fail", "http://localhost/zm/api/host/getVersion.json"] || exit 1


# Setup Volumes
VOLUME /var/cache/zoneminder/events /var/cache/zoneminder/images /var/lib/mysql /var/log/zm

# Expose http port
EXPOSE 80

# Configure entrypoint
COPY utils/entrypoint.sh /usr/local/bin/
RUN chmod 755 /usr/local/bin/entrypoint.sh
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
