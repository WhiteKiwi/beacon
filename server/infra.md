# Infrastructure

## Request Flow

```text
Client
  -> beacon.whitekiwi.link
  -> Route 53 A record
  -> KT router public IP
  -> KT router port forwarding 10422/tcp
  -> Mac mini nginx 10422/tcp
  -> local Beacon server http://127.0.0.1:20422
```

## DNS

- Domain: `beacon.whitekiwi.link`
- DNS provider: AWS Route 53
- Record type: `A`
- Target: public IP address for the KT router

## Router

- Router: KT router
- External port: `10422/tcp`
- Internal destination: this Mac mini
- Internal port: `10422/tcp`

The router forwards inbound traffic for `10422/tcp` to the Mac mini on the same port.

## nginx

nginx runs on the Mac mini and listens for HTTPS traffic on `10422/tcp`.

Responsibilities:

- Terminate TLS for `beacon.whitekiwi.link`
- Receive inbound HTTPS requests from the router
- Proxy requests to the local Beacon server over HTTP

Expected upstream:

```text
http://127.0.0.1:20422
```

## Beacon Server

The Beacon server runs locally on the Mac mini as an HTTP service.

- Runtime: NestJS
- Protocol: HTTP
- Host: `127.0.0.1`
- Port: `20422`
- Env file: `server/.env`

The server does not handle TLS directly. TLS is handled by nginx.
