import fs from "fs";
import parse from "csv-parse/lib/sync";

const loadPopulation = function (): Map<number, number> {
  const populationFile = fs.readFileSync("./data/population.csv", {
    encoding: "utf8",
  });

  const populationRows = parse(populationFile);
  const acc = new Map();

  populationRows.forEach((row: string[]) => {
    let fip: number = parseInt(row[0], 10);
    let population: number = parseInt(row[3], 10);
    acc.set(fip, population);
  });

  return acc;
};

const popMap: Map<number, number> = loadPopulation();

const population = function (fip: number): number {
  let population = popMap.get(fip);

  if (population === undefined) {
    throw new Error(`No population found for county fip ${fip}`);
  }

  return population;
};

export default population;
