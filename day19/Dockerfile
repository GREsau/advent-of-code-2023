FROM debian

RUN dpkg --add-architecture i386 \
    && apt update \
    && apt install -y wget libc6:i386 libcurl4:i386 libgtk-3-0:i386 libgdk-pixbuf2.0-0:i386 \
    && wget https://static.red-lang.org/dl/auto/linux/red-18dec23-971b127ae -O /usr/bin/red \
    && chmod +x /usr/bin/red \
    && apt remove -y wget \
    && rm -rf /var/lib/apt/lists/*

CMD ["red"]
