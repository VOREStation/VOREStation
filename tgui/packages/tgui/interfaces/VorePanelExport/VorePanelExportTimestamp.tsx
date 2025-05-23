export const getCurrentTimestamp = (): string => {
  let now = new Date();
  let hours = String(now.getHours());
  if (hours.length < 2) {
    hours = '0' + hours;
  }
  let minutes = String(now.getMinutes());
  if (minutes.length < 2) {
    minutes = '0' + minutes;
  }
  let dayofmonth = String(now.getDate());
  if (dayofmonth.length < 2) {
    dayofmonth = '0' + dayofmonth;
  }
  let month = String(now.getMonth() + 1); // 0-11
  if (month.length < 2) {
    month = '0' + month;
  }
  let year = String(now.getFullYear());

  return (
    ' ' +
    year +
    '-' +
    month +
    '-' +
    dayofmonth +
    ' (' +
    hours +
    ' ' +
    minutes +
    ')'
  );
};
