# Make sure you have postgresql contrib installed
# &> sudo apt-get update
#
# Find out which version of PG you’re running
# $> pg_lsclusters
#
# PostgreSQL 9.3:
# $> sudo apt-get install postgresql-contrib-9.3
#
# PostgreSQL 9.4:
# $> sudo apt-get install postgresql-contrib-9.4

psql template1 -c 'CREATE EXTENSION hstore;'
psql template1 -c 'CREATE EXTENSION citext;'
psql -c "CREATE DATABASE pm_app_dev;"
psql -c "CREATE USER pm_app_dev WITH PASSWORD 'test';"
psql -c "ALTER USER pm_app_dev WITH SUPERUSER;"
psql -c "ALTER DATABASE pm_app_dev OWNER to pm_app_dev;"
psql -c "GRANT ALL PRIVILEGES ON DATABASE pm_app_dev to pm_app_dev;"
psql -c "ALTER USER pm_app_dev CREATEDB;"
psql -c "CREATE DATABASE pm_app_test;"
psql -c "CREATE USER pm_app_test WITH PASSWORD 'test';"
psql -c "ALTER DATABASE pm_app_test OWNER to pm_app_test;"
psql -c "GRANT ALL PRIVILEGES ON DATABASE pm_app_test to pm_app_test;"
psql -c "ALTER USER pm_app_test CREATEDB;"
