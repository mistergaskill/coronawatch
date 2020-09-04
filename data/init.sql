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

CREATE MATERIALIZED VIEW daily_cases (fips, reporting_date, total)
AS SELECT curr.fips, curr.reporting_date, curr.total - prev.total
FROM cases as curr
INNER JOIN cases as prev
ON curr.fips = prev.fips AND curr.reporting_date - prev.reporting_date = 1;

CREATE UNIQUE INDEX ON daily_cases (fips, reporting_date);