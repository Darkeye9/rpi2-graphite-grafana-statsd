Image based on Arch Linux ARM.

Whisper, Carbon and Graphite-API installed from pip2 (Python2).
StatsD cloned from repo.
Grafana, downloaded from the 2.6.0 tar.gz and builded from sources.

All of this managed by Supervisord, and exposed on ports:
3000: Grafana
2003: Graphite Line Receiver
8125: StatsD

You can simply start an instance with:

	docker run -itd -p 2003:2003 -p 8125:8125 -p 8125:8125/udp -p 3000:3000 --name stats darkeye9/rpi2-graphite-grafana-statsd

Link to Docker Hub : https://hub.docker.com/r/darkeye9/rpi2-graphite-grafana-statsd/

