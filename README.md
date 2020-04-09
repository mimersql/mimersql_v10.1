# Mimer SQL version 10.1

This is a docker build of Mimer SQL version 10.1. It comes with a ten user license, the same that all our free downloads come with; see https://developer.mimer.com/product-overview/downloads/

## Running Mimer
Run the container with
`docker run -p 1360:1360 -d mimersql/mimersql_v10.1:latest`

This launches a Mimer SQL database server that is accessible on port 1360, the standard port for Mimer SQL.

## Connecting to the database
Access Mimer using for instance DBVisualizer (https://www.dbvis.com) which comes with a JDBC driver and support for Mimer. With the example above is the host `localhost` and the port 1360. Login as "SYSADM", password "SYSADM".

The JDBC connection string would then be

## Saving data between containers
Since the container is a separate entite, the above solution will lose all data when the container is killed. There are several solutions to this but the easiest in a test scenario is top map a directory on the host system to the container, thus causing all file writes to happen in the host file system which is persistent.

The strategy will be this:

1. Start a fresh copy of the Mimer SQL container, which will create an emtpy database
1. Copy the empty database from the conainer to the host file system
1. Kill the container
1. Start a new conatiner with Mimer SQL, only to this time replace the container's path to the database with a mapping to the host file system.

This way, when the container is killed, all data resides in the persistent host file system and can be accessed when launching a new container (that is mapped correctly).

Since this is a permanent database, we strongly recommend changing the password for the SYSADM user from the default.

### Procedure
1. Create a fresh database using a seeding container
`docker run -d mimersql/mimersql_v10.1:latest`

1. Find the ID of this container
`docker ps -l -q` -- this provides a 12 digits hexadecimal number, e.g., `9bee88caa0ac`

1. Copy the database to the local filesystem using this ID
`docker cp 9bee88caa0ac:/usr/local/MimerSQL/mimerdb .`

1. Kill the seeding container
`docker kill 9bee88caa0ac`

1. Start a new container, this time mapping the host local database into the container, thus replacing it
`docker run -v mimerdb:/usr/local/MimerSQL/mimerdb -p 1360:1360 -d mimersql/mimersql_v10.1:latest`

## Acknowledgements
Oscar Armer, Savant, for the inspiration.