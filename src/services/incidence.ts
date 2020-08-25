import { getWeeklyAverage } from "./cases";
import population from "./population";

const incidence = function (fip: number) {
  const average: number = getWeeklyAverage(fip);
  const countyPopulation: number = population(fip);
  const raw = average / (countyPopulation / 100000);
  return Math.round(raw * 10) / 10;
};

export default incidence;
