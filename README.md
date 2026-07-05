# Traefik for Docker Compose

A set of example Docker Compose stacks for different use cases to get up and running with Traefik in no time.

## Setting Up Traefik Basic Auth

Reference guide for setting up Traefik [BasicAuth](https://doc.traefik.io/traefik/reference/routing-configuration/http/middlewares/basicauth/) middleware for the dashboard.

1. Generate a bcrypt password hash using a temporary Docker container:

   ```bash
   docker run --rm -it httpd:alpine htpasswd -nB -C 12 adminuser
   ```

   `-C 12` sets the bcrypt cost. Lower defaults such as cost `05` are functional but not recommended for internet-exposed Basic Auth.

   Enter your password when prompted. The output will look like:

   ```text
   adminuser:$2y$12$abcdefghijklmnopqrstuvwxyz...
   ```

> [!IMPORTANT]
> Escape `$` characters in Docker Compose. Compose treats `$` as variable interpolation syntax, so every `$` in the bcrypt hash must become `$$` in the label.

   ```text
   adminuser:$2y$12$...  ->  adminuser:$$2y$$12$$...
   ```

2. Add the user to your compose labels.

   For a single user:

   ```yml
   - 'traefik.http.middlewares.auth.basicauth.users=adminuser:$$2y$$12$$...'
   ```

   For multiple users, separate with commas:

   ```yml
   - 'traefik.http.middlewares.auth.basicauth.users=adminuser:$$2y$$12$$...,alice:$$2y$$12$$...'
   ```

   Or abstract to an environment variable:

   ```yml
   - 'traefik.http.middlewares.auth.basicauth.users=${TRAEFIK_AUTH_USERS}'
   ```

3. Recreate the container after changing Basic Auth users.

   ```shell
   docker compose up -d --force-recreate <service_name>
   ```

4. Deploy the stack.

   Traefik reads the inline label and enforces Basic Auth on every request. The browser will prompt for credentials on first visit and cache them for the session.

> [!NOTE]
> Password hashes are visible in Docker metadata (`docker inspect`) but remain bcrypt-hashed. Treat them as sensitive.
