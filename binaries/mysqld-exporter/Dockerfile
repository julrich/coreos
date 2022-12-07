FROM fedora:25
MAINTAINER julrich

RUN dnf install -y git tar gcc systemd systemd-devel make findutils && dnf -y clean all

RUN mkdir -p /go/src/github.com/percona/mysqld_exporter
ENV GOLANG_VERSION 1.7.4
ENV GOPATH /go
ENV GIMME_ENV_PREFIX /go/envs
RUN curl -sLo /go/gimme https://raw.githubusercontent.com/travis-ci/gimme/master/gimme \
  && chmod +x /go/gimme \
  && /go/gimme ${GOLANG_VERSION}

WORKDIR /go/src/github.com/percona/mysqld_exporter
CMD . ${GIMME_ENV_PREFIX}/go${GOLANG_VERSION}.env \
  && go get -t -v ./... \
  && go test -v ./... \
  && go build . \
  && chmod 0666 mysqld_exporter

# For the origins of this file, see:
# * https://github.com/mheese/journalbeat/blob/master/ci/common.dockerfile.part
# * https://github.com/mheese/journalbeat/blob/master/ci/fedora.dockerfile.part
#
# We're using Fedora 25 because it uses the exact same systemd version as
# packaged on our machines (as of this writing: 231). Not exactly clear if this
# really matters, because journalbeat uses some patched version of systemd
# for linking while building, but if in question: better be safe than sorry.