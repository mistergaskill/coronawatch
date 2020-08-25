import { getWeeklyAverage } from "./cases";

test("get weekly average cases", () => {
  expect(getWeeklyAverage(6013)).toEqual(205);
});
