import csv
import itertools


def get_normalized_rows(input_row, dates):
    fip = row[0]
    case_counts = row[4:]
    return zip(itertools.repeat(fip), dates, case_counts)


with open('data/cases.csv') as cases_input, open('data/cases_normalized.csv', 'w') as cases_output:
    reader = csv.reader(cases_input)
    writer = csv.writer(cases_output)
    writer.writerow(['fip', 'date', 'total'])

    dates = next(reader)[4:]

    for row in reader:
        new_rows = get_normalized_rows(row, dates)
        for new_row in new_rows:
            writer.writerow(new_row)
