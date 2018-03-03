# Check that all envirment variables have been set.
echo "CASSANDRA_IP:$CASSANDRA_IP"
echo "CASSANDRA_PORT:$CASSANDRA_PORT"
echo "CASSANDRA_ADMIN_USERNAME:$CASSANDRA_ADMIN_USERNAME"
echo "CASSANDRA_ADMIN_PASSWORD:$CASSANDRA_ADMIN_PASSWORD"

# Echo all commands for debug.
set -x

# Inject the username and password of new admin into the cql script.
sed -i s/\<CASSANDRA_ADMIN_USERNAME\>/$CASSANDRA_ADMIN_USERNAME/g $1 /scripts/createAdmin.cql
sed -i s/\<CASSANDRA_ADMIN_PASSWORD\>/$CASSANDRA_ADMIN_PASSWORD/g $1 /scripts/createAdmin.cql
cqlsh -u cassandra -p cassandra -f /scripts/createAdmin.cql $CASSANDRA_IP $CASSANDRA_PORT

# Set Cassandra Admin password to a random string.
RANDOM_PASSWORD=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)
sed -i s/\<RANDOM_PASSWORD\>/$RANDOM_PASSWORD/g $1 /scripts/scrambleCassandraAdminPassword.cql
cqlsh -u $CASSANDRA_ADMIN_USERNAME -p $CASSANDRA_ADMIN_PASSWORD -f /scripts/scrambleCassandraAdminPassword.cql $CASSANDRA_IP $CASSANDRA_PORT
