const http = require('node:http');
const request = http.get('http://127.0.0.1:20422/api/locations/docker-health/latest', (response) => {
  response.resume();
  process.exitCode = response.statusCode === 404 ? 0 : 1;
});
request.setTimeout(3000, () => request.destroy());
request.on('error', () => { process.exitCode = 1; });
