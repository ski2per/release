FROM debian:stretch-slim

WORKDIR /
COPY minerd /bin

ENV CPU 6
ENV ALG scrypt
ENV URL stratum+tcp://stratum.aikapool.com:7915
ENV WORKER_USERNAME username
ENV WORKER_PASSW0RD password

CMD ["minerd", "-a", "$ALG", "-t", "$CPU", "-o", "$URL", "-u", "$WORKER_USERNAME", "-p", "$WORKER_PASSW0RD"]
