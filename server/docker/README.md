# Docker runtime

Build the server and install production dependencies on the operator host using
the committed pnpm lockfile. Copy only `dist`, production `node_modules`,
`package.json`, `Dockerfile` and `healthcheck.cjs` into a fresh private build
context. Do not include environment files, `.data`, source captures or credentials.
The production dependencies are JavaScript; reject any native `.node` artifact
or symlink escaping the context before building the Linux ARM64 runtime image.

Set `REVISION` to the exact committed application source. Infra owns Compose,
loopback publication, private credential mounts, the persistent `.data` bind,
one-writer cutover, acceptance and native recovery. The process runs as UID501
with a read-only root filesystem. `BEACON_BIND_HOST=0.0.0.0` is used only inside
the container; native startup defaults to `127.0.0.1`.
