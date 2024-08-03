FROM arm32v7/debian:buster
ENV DEBIAN_FRONTEND=noninteractive

RUN groupadd -r mysql 
RUN useradd -r -g mysql mysql

RUN apt-get update && apt-get install -y perl --no-install-recommends && rm -rf /var/lib/apt/lists/*

RUN apt-cache search mysql


RUN apt-get update && apt-get install -y mysql-server && rm -rf /var/lib/apt/lists/* \
	&& rm -rf /var/lib/mysql && mkdir -p /var/lib/mysql && chown -R mysql:mysql /var/lib/mysql

# comment out a few problematic configuration values
RUN sed -Ei 's/^(bind-address|log)/#&/' /etc/mysql/my.cnf

VOLUME /var/lib/mysql

COPY docker-entrypoint.sh /usr/local/bin/
ENTRYPOINT ["docker-entrypoint.sh"]

EXPOSE 3306
CMD ["mysqld"]
