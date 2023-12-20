FROM debian

RUN apt update \
    && apt install -y tcl tcl-tclreadline \
    && rm -rf /var/lib/apt/lists/*

ADD https://raw.githubusercontent.com/flightaware/tclreadline/v2.3.8/sample.tclshrc /root/.tclshrc

CMD ["tclsh"]
