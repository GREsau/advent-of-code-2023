FROM debian

RUN apt update \
    && apt install -y fis-gtm pkg-config \
    && rm -rf /var/lib/apt/lists/* \
    && find /usr/lib -name gtmprofile -not -wholename '*/utf8/*' | xargs -I '{}' ln -s {} /usr/local/bin

COPY docker-entrypoint.sh /

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["gtm"]
