FROM node:24.15.0-bookworm-slim@sha256:4e6b70dd6cbfc88c8157ba19aa3d9f9cce6ba4703576d55459e45efcbc9c5f5d
ARG REVISION
LABEL org.opencontainers.image.source="https://github.com/WhiteKiwi/beacon" \
      org.opencontainers.image.revision=$REVISION
WORKDIR /app
COPY dist ./dist
COPY node_modules ./node_modules
COPY package.json healthcheck.cjs ./
RUN mkdir -p /data/.data && chown -R 501:20 /data
ENV NODE_ENV=production ENV=live PORT=20422 BEACON_BIND_HOST=0.0.0.0
USER 501:20
WORKDIR /data
HEALTHCHECK --interval=15s --timeout=4s --start-period=30s --retries=3 CMD ["node", "/app/healthcheck.cjs"]
CMD ["node", "--env-file=/run/beacon/production.env", "/app/dist/main.js"]
