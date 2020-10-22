const fetch = require('node-fetch');
const parse = require('csv-parse/lib/sync')

let CASES_URL = 'https://usafactsstatic.blob.core.windows.net/public/data/covid-19/covid_confirmed_usafacts.csv'
let POPULATION_URL = 'https://usafactsstatic.blob.core.windows.net/public/data/covid-19/covid_county_population_usafacts.csv'

const { Client } = require('pg')

const client = new Client({
  host: 'localhost',
  port: 5432,
  database: 'coronawatch',
  user: 'postgres',
  password: 'DjIyownrqD2yo6x9',
});

function saveCaseRow(county, dates) {
    let [fips,,,,...counts] = county;

    return Promise.all(dates.map((date, i) => {
        let count = counts[i];
        let query = `INSERT into cases (fips, reporting_date, total) VALUES ($1, $2, $3);`
        console.log([fips, date, count])
        return client.query(query, [fips, date, count]);
    })); 
}

async function loadCaseData() {
    const [, response]  = await Promise.all([
        client.connect(),
        fetch(CASES_URL)
    ]);

    const records = parse(await response.text(), {
        columns: false,
        skip_empty_lines: true
    });

    let [,,,,...dates] = records[0];
 
    await Promise.all(records.slice(1,10)
    .filter(county =>  county[0] !== '0') // filter out statewide unallocated rows which have a fips of 0
    .map(county => saveCaseRow(county, dates)));

    // let result = await client.query(`INSERT into cases (fips, reporting_date, total) VALUES (1, '10/10/20', 500);`);
    await client.end();
}

loadCaseData();

exports.loadCaseData = loadCaseData;