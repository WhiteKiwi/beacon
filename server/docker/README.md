# Docker runtime

Build the server and install production dependencies on the operator host using
the committed pnpm lockfile. Copy only `dist`, production `node_modules`,
`package.json`, `Dockerfile` and `healthcheck.cjs` into a fresh private build
context. Do not include environment files, `.data`, source captures or credentials.
The production dependencies are JavaScript; reject any native `.node` artifact
or symlink escaping the context before building the selected Linux ARM64 or AMD64 runtime image.

Set `REVISION` to the exact committed application source. Infra owns Compose,
loopback publication, private credential mounts, the persistent `.data` bind,
one-writer cutover, acceptance and native recovery. The process runs as UID501
with a read-only root filesystem. `BEACON_BIND_HOST=0.0.0.0` is used only inside
the container; native startup defaults to `127.0.0.1`.

K3s uses a single writer protected by flock on `/data/.data/.writer.lock`.
The service directory uses its operator group with setgid; JSON mode0640 permits
the owning operator to verify and recover files without making coordinates public.
Successful location responses follow file and directory sync. Shutdown rejects new writes
and drains accepted saves. `/healthz` checks the HTTP process independently of storage.
