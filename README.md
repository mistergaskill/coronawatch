# Setup
- Install [docker](https://docs.docker.com/engine/install/ubuntu/)
- Install [docker-compose](https://docs.docker.com/compose/install/)

# Fetching the latest data
Download the latest case, death and population data:

`python3 script/fetch_cases.py`

Compile the local csv data into a normalized csv:

`python3 script/pivot_cases.py`


# Running
`docker-compose up`
Login to Grafana at `http://127.0.0.1:3000`

# How to Connect to the Database
>Config found in docker-compose.yml and postgres.env
host: 172.18.0.1:5432
database: coronawatch
password: covid19
user: coronawatch
ssl mode: disabled
psql version: 9.4