import fs from "fs";
import parse from "csv-parse/lib/sync";

const casesFile = fs.readFileSync("./data/cases.csv", { encoding: "utf8" });

const casesRows = parse(casesFile);
const caseTotalMap = new Map<number, number[]>();

casesRows.forEach((row: string[]) => {
  let fip: number = parseInt(row[0], 10);
  let totals: number[] = row.slice(4).map((x: string) => parseInt(x, 10));
  caseTotalMap.set(fip, totals);
});

function total(fip: number): number[] {
  let totals = caseTotalMap.get(fip);
  if (totals === undefined) {
    throw new Error(`Could not find cases for county fip ${fip}`);
  }
  return totals;
}

function daily(fip: number): number[] {
  let totals: number[] = total(fip);
  let dailies: number[] = [totals[0]];

  totals.slice(1).forEach((total, index) => {
    dailies.push(total - totals[index]);
  });

  return dailies;
}

function getWeeklyAverage(fip: number): number {
  let totals: number[] = total(fip).slice(-8);
  return (totals[7] - totals[0]) / 7;
}

export { total, daily, getWeeklyAverage };
