FROM cassandra:3.11

LABEL maintainer="awgreene"

ADD ./scripts ./scripts

CMD ["./scripts/cassandraInitAdmin.sh"]

