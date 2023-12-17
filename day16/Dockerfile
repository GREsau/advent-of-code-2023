FROM debian as build

RUN apt update \
    && apt install -y chezscheme build-essential libgmp-dev wget \
    && rm -rf /var/lib/apt/lists/* \
    && wget https://www.idris-lang.org/idris2-src/idris2-0.6.0.tgz \
    && tar -xzf idris2-0.6.0.tgz \
    && cd Idris2-0.6.0 \
    && make bootstrap SCHEME=chezscheme \
    && make install

FROM debian
COPY --from=build /root/.idris2/ /root/.idris2/

RUN apt update \
    && apt install -y chezscheme \
    && rm -rf /var/lib/apt/lists/* \
    && ln -s /root/.idris2/bin/idris2 /usr/local/bin

CMD idris2
