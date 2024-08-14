# Traefik for Docker Compose
A basic Traefik network configuration for local development.

## Example Usage
```yml
# Basic Vue SPA app
# TRAEFIK_PORT=8000 (any local port) setup in .env
# Configured server.port in vite.config.js file with the same value
# vue-spa.example.localhost will resolve with a running Vite dev server using: `npm run dev`
services:
  primevue_breeze_spa:
    build: node:20-alpine
    container_name: primevue_breeze_spa
    entrypoint: /bin/sh
    working_dir: /web
    volumes:
      - '.:/web'
    tty: true
    ports:
      - "80:80"
    labels:
      - "traefik.enable=true"
      - "traefik.http.routers.primevue_breeze_spa.rule=Host(`vue-spa.example.localhost`)"
      - "traefik.http.services.primevue_breeze_spa.loadbalancer.server.port=${TRAEFIK_PORT}"
    networks:
      - proxy

networks:
  proxy:
    name: "traefik_network"
```