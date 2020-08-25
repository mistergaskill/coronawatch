import incidence from "./incidence";

test("get incidence for Orange County", () => {
  expect(incidence(6059)).toEqual(10.7);
});

test("get incidence for Contra Cost Count", () => {
  expect(incidence(6013)).toEqual(15.5);
});
