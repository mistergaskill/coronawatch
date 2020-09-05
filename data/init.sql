CREATE TABLE counties_temp (
    fips int,
    name VARCHAR(64),
    state VARCHAR(2),
    population int
);

COPY counties_temp(fips, name, state, population)
FROM '/data/population.csv'
DELIMITER ','
CSV HEADER;

CREATE TABLE counties (
    fips int PRIMARY KEY,
    name VARCHAR(64) NOT NULL,
    state VARCHAR(2) NOT NULL,
    population int NOT NULL
);

INSERT INTO counties
SELECT *
FROM counties_temp
WHERE fips <> 0
ORDER BY fips;

DROP TABLE counties_temp;

CREATE TABLE cases_temp (
    fips int,
    reporting_date DATE,
    total int 
);

COPY cases_temp(fips, reporting_date, total)
FROM '/data/cases_normalized.csv'
DELIMITER ','
CSV HEADER;

CREATE TABLE cases (
    fips int,
    reporting_date DATE,
    total int NOT NULL,
    PRIMARY KEY(fips, reporting_date)
);

INSERT INTO cases
SELECT *
FROM cases_temp
WHERE fips > 1
ORDER BY fips;

DROP TABLE cases_temp;

SELECT
    CONCAT(counties.name, ', ', counties.state) as county,
    curr.reporting_date + time '00:00:00' as collected,
    curr.total - prev.total as total
INTO daily_cases
FROM cases as curr
INNER JOIN counties
ON counties.fips = curr.fips
INNER JOIN cases as prev
ON curr.fips = prev.fips AND curr.reporting_date - prev.reporting_date = 1;

ALTER TABLE daily_cases ADD PRIMARY KEY (county, collected);

SELECT
    CONCAT(counties.name, ', ', counties.state) as county,
    today.reporting_date + time '00:00:00' as collected,
    today.total as total,
    today.total - yesterday.total as daily_cases,
    today.total - last_week.total as weekly_cases,
    (today.total - yesterday.total) / (counties.population / 100000.0) as daily_cases_per_100k,
    (today.total - last_week.total) / (counties.population / 100000.0) as weekly_cases_per_100k
INTO stats
FROM cases as today
INNER JOIN counties
ON counties.fips = today.fips
INNER JOIN cases as yesterday
ON today.fips = yesterday.fips AND today.reporting_date - yesterday.reporting_date = 1
INNER JOIN cases as last_week
ON today.fips = last_week.fips AND today.reporting_date - last_week.reporting_date = 7
WHERE counties.population > 0;

ALTER TABLE stats ADD PRIMARY KEY (county, collected);