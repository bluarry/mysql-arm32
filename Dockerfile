FROM arm32v7/debian:buster
ENV DEBIAN_FRONTEND=noninteractive

RUN groupadd -r mysql 
RUN useradd -r -g mysql mysql

RUN apt-get update && apt-get install -y perl --no-install-recommends && rm -rf /var/lib/apt/lists/*

RUN apt-get update && apt-get install -y mysql-* && rm -rf /var/lib/apt/lists/* \
	&& rm -rf /var/lib/mysql && mkdir -p /var/lib/mysql && chown -R mysql:mysql /var/lib/mysql

# comment out a few problematic configuration values
RUN sed -Ei 's/^(bind-address|log)/#&/' /etc/mysql/my.cnf

VOLUME /var/lib/mysql

COPY docker-entrypoint1.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint1.sh
ENTRYPOINT ["/usr/local/bin/docker-entrypoint1.sh"]

EXPOSE 3306
CMD ["mysqld"]
