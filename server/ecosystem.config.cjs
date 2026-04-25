module.exports = {
  apps: [
    {
      name: 'beacon-server',
      cwd: __dirname,
      script: 'dist/main.js',
      instances: 1,
      exec_mode: 'fork',
      watch: false,
      time: true,
      env: {
        NODE_ENV: 'production',
        ENV: 'live',
        PORT: 20422,
      },
    },
  ],
};
