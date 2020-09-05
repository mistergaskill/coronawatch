import csv
import requests

CASES_URL = 'https://usafactsstatic.blob.core.windows.net/public/data/covid-19/covid_confirmed_usafacts.csv'
DEATHS_URL = 'https://usafactsstatic.blob.core.windows.net/public/data/covid-19/covid_deaths_usafacts.csv'
POPULATION_URL = 'https://usafactsstatic.blob.core.windows.net/public/data/covid-19/covid_county_population_usafacts.csv'


def save(path, url):
    r = requests.get(url)

    with open(path, 'w') as out:
        out.write(r.text)


save('data/cases.csv', CASES_URL)
save('data/deaths.csv', DEATHS_URL)
save('data/population.csv', POPULATION_URL)
