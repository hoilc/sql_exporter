FROM golang:1.20-alpine as builder

RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories && \
  apk add git bash

ENV GO111MODULE=on
ENV GOPROXY=https://proxy.golang.com.cn,direct

# Add our code
COPY ./ /src

# build
WORKDIR /src
RUN go build -ldflags "-s -w" -v -o /sql_exporter .

# multistage
FROM quay.io/prometheus/busybox:latest

COPY --from=builder /sql_exporter /usr/bin/sql_exporter

EXPOSE 9237

ENTRYPOINT [ "/usr/bin/sql_exporter" ]