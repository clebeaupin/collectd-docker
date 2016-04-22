FROM debian:stretch

COPY . /go/src/github.com/bobrik/collectd-docker

RUN /go/src/github.com/bobrik/collectd-docker/docker/build.sh

ENTRYPOINT ["/run.sh"]
CMD collectd -f -C /tmp/collectd.conf > /dev/null
