
FROM mockersf/rpi2-archlinuxarm:latest

MAINTAINER Dark_eye (dark.eye9@gmail.com)

RUN pacman -Syu --noconfirm &&\
	pacman -S --noconfirm python2-pip gcc supervisor nodejs git libffi cairo go npm wget nodejs-grunt-cli patch
RUN pip2 install whisper
RUN pip2 install carbon
RUN pip2 install gunicorn
RUN CFLAGS=-I/usr/lib/libffi-3.2.1/include/ pip2 install graphite-api

ADD res/* /

RUN cp /opt/graphite/conf/carbon.conf.example /opt/graphite/conf/carbon.conf && \
	cp /opt/graphite/conf/storage-aggregation.conf.example /opt/graphite/conf/storage-aggregation.conf && \
	cp /opt/graphite/conf/storage-schemas.conf.example /opt/graphite/conf/storage-schemas.conf && \
	patch -p0 < storage-schemas.conf.patch && \
	patch -p0 < storage-aggregation.conf.patch && \
	cp /graphite-api.yaml /etc/

WORKDIR /root/

RUN git clone https://github.com/etsy/statsd.git

RUN wget https://github.com/grafana/grafana/archive/v2.6.0.tar.gz && \
	tar xf v2.6.0.tar.gz && mkdir -p src/github.com/grafana/grafana/ && \
	shopt -s dotglob && mv grafana-2.6.0/* src/github.com/grafana/grafana/

RUN export GOPATH=`pwd` && cd $GOPATH/src/github.com/grafana/grafana && \
	go run build.go setup && \
	$GOPATH/bin/godep restore && \
	go run build.go build

RUN cd /root/src/github.com/grafana/grafana && npm install; exit 0

RUN cd /root/src/github.com/grafana/grafana && grunt --force

EXPOSE 3000
EXPOSE 2003
EXPOSE 8125

CMD supervisord -c /supervisor.conf

