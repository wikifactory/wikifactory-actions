const fs = require("fs");
const path = require("path");
const core = require("@actions/core");
const process = require("process");

try {
  function incrementVersion(version) {
    const parts = version.split(".");
    if (parts[2] < 9) {
      parts[2]++;
    } else {
      parts[2] = 0;
      if (parts[1] < 9) {
        parts[1]++;
      } else {
        parts[1] = 0;
        parts[0]++;
      }
    }
    return parts.join(".");
  }

  const pathInput = core.getInput("path");
  const fullPath = path.join(process.env.GITHUB_WORKSPACE, pathInput);

  const packageDataRaw = fs.readFileSync(fullPath, "utf8"); // Use 'utf8' encoding to get a string
  const packageData = JSON.parse(packageDataRaw);

  packageData.version = incrementVersion(packageData.version);

  fs.writeFileSync(fullPath, JSON.stringify(packageData, null, 2) + "\n");

  core.setOutput("new-version", packageData.version);
} catch (error) {
  core.setFailed(error.message);
}
