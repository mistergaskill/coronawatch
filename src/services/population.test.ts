import population from "./population";

test("get the population of Contra Costa County", () => {
  expect(population(6013)).toEqual(1153526);
});

test("get the population of Orange County", () => {
  expect(population(6059)).toEqual(3175692);
});

test("can't find population for non existant county", () => {
  expect(() => population(1)).toThrow("No population found for county fip 1");
});
