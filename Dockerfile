#
# This is a Dockerfile that uses Ubuntu and installs nordlynx to facilitate retrieving the private key for those people who are not already on a linux machine.
#

FROM ubuntu:24.04

RUN apt-get update && \
    apt-get install -y curl && \
    apt-get install -y wireguard && \ 
    apt-get install -y --no-install-recommends wget apt-transport-https ca-certificates && \
    apt-get install -y --no-install-recommends wget apt-transport-https ca-certificates && \ 
    wget -qO /etc/apt/trusted.gpg.d/nordvpn_public.asc https://repo.nordvpn.com/gpg/nordvpn_public.asc && \
    echo "deb https://repo.nordvpn.com/deb/nordvpn/debian stable main" > /etc/apt/sources.list.d/nordvpn.list && \
    apt-get update && \
    apt-get install -y --no-install-recommends nordvpn && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

COPY get_creds.sh /

ENTRYPOINT ["/bin/bash", "/get_creds.sh"]
