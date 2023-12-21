FROM debian

RUN apt update \
    && apt install -y wget default-jre unzip \
    && wget https://github.com/JetBrains/kotlin/releases/download/v1.9.21/kotlin-compiler-1.9.21.zip \
    && unzip kotlin-compiler-1.9.21.zip \
    && rm kotlin-compiler-1.9.21.zip \
    && apt remove -y wget unzip \
    && rm -rf /var/lib/apt/lists/*

ENV PATH="$PATH:/kotlinc/bin"

CMD ["kotlin"]
