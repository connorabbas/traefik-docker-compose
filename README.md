# Traefik for Docker Compose
A basic Traefik network configuration for local development.

## Example Usage
```yml
# Basic Vue SPA app
# VITE_PORT=8000 setup in .env
# Configured server.port in vite.config.js file with the same value
# vue-spa.localhost will resolve with a running Vite dev server using: `npm run dev`
services:
  web:
    build: node:20-alpine
    container_name: vue_spa
    entrypoint: /bin/sh
    working_dir: /web
    volumes:
      - '.:/web'
    tty: true
    ports:
      - "80:80"
    labels:
      - "traefik.enable=true"
      - "traefik.http.routers.vue_spa.rule=Host(`vue-spa.localhost`)"
      - "traefik.http.services.vue_spa.loadbalancer.server.port=${VITE_PORT}"
    networks:
      - proxy

networks:
  proxy:
    name: "traefik_network"
    external: true
```