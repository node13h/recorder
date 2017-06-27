FROM java:8
RUN wget https://github.com/riemann/riemann/releases/download/0.2.13/riemann-0.2.13.tar.bz2 && tar -xf riemann-0.2.13.tar.bz2 && ln -s /riemann-0.2.13 /riemann
COPY riemann.config /riemann/etc/riemann.config
EXPOSE 5555 5555/udp 5556
CMD ["/riemann/bin/riemann","/riemann/etc/riemann.config"]