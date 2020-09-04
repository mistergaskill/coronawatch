CREATE TABLE counties (
    fips int PRIMARY KEY,
    name VARCHAR(64) NOT NULL,
    state VARCHAR(2) NOT NULL,
    population int NOT NULL
);

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

INSERT INTO counties
SELECT *
FROM counties_temp
WHERE fips <> 0
ORDER BY fips;

DROP TABLE counties_temp;