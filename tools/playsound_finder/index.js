var fs = require("fs");

// List all files in a directory in Node.js recursively in a synchronous fashion
var walkSync = (dir, filelist) => {
  var files = fs.readdirSync(dir);
  filelist = filelist || [];
  files.forEach((file) => {
    if (fs.statSync(dir + file).isDirectory()) {
      filelist = walkSync(dir + file + "/", filelist);
    } else {
      filelist.push(dir + file);
    }
  });
  return filelist;
};

var findNearestAbsolute = (data, line) => {
  for (let i = line; i > 0; i--) {
    const str = data[i];
    if (str?.match(/^\//)) {
      return str.trim().replace(/,/g, "|");
    }
  }
  return null;
};

var main = () => {
  const files = walkSync("code/");
  const matches = {};
  for (const file of files) {
    const data = fs.readFileSync(file, "utf8");

    if (!data.match(/playsound.*/)) {
      continue;
    }

    if (!matches[file]) matches[file] = [];
    const dataArray = data.split("\n");

    let i = 1;
    for (const line of dataArray) {
      i++;
      const m = line.match(/playsound.*/);
      if (m) {
        matches[file].push({
          line: i,
          match: m[0],
          src: findNearestAbsolute(dataArray, i),
        });
      }
    }
  }

  Object.keys(matches).map((file) => {
    const allResults = matches[file];
    allResults.map((obj) => {
      obj.params = obj.match.split(",");
      for (let i = 0; i < obj.params.length; i++) {
        obj.params[i] = obj.params[i]
          .trim()
          .replace(/playsound\(/g, "")
          .replace(/\)/g, "");
      }
    });
  });

  // Final loop, spit out a csv
  Object.keys(matches).map((file) => {
    let thisFileCsvEntry = "";
    const allResults = matches[file];
    for (const matchObj of allResults) {
      thisFileCsvEntry += `${file},${matchObj.line},${matchObj.src},${matchObj.params.join(",")}\n`;
    }
    fs.appendFileSync("results.csv", thisFileCsvEntry);
  });
};

main();
