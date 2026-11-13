# Greg

A quiet personal site for writing, built with [Zola](https://www.getzola.org/).

## Docker preview

Validate the Compose configuration, build the latest site from the remote
`main` branch, and start it in the background:

```bash
docker compose config --quiet
docker compose up --build -d
```

Open [http://localhost:8080](http://localhost:8080). The container runs Nginx
as an unprivileged user, exposes the service only on localhost, and has a
read-only filesystem with a health check. Set `DOSE_PORT` to use another local
port:

```bash
DOSE_PORT=8081 docker compose up --build -d
```

The source repository and Git ref can be overridden at build time. Use an
immutable commit hash for a reproducible build; this example uses `main`:

```bash
docker compose --progress=plain build --pull \
  --build-arg SITE_REF=main \
  --build-arg SITE_REPOSITORY=https://github.com/gregorybfoulkes/dose.git site
docker compose up -d
```

Replace `main` with a branch, tag, or commit hash to build another revision.

### Inspect and review

```bash
# Container state, health, restart count, and published port
docker compose ps --all
docker inspect --format \
  'status={{.State.Status}} health={{if .State.Health}}{{.State.Health.Status}}{{else}}not-configured{{end}} restarts={{.RestartCount}}' \
  "$(docker compose ps -q site)"
docker compose port site 8080

# Nginx configuration and runtime identity
docker compose exec site nginx -t
docker compose exec site sh -c 'id; nginx -T 2>&1 | tail -n 40'

# Verify the HTTP response and image metadata
curl --fail --show-error --silent \
  "http://127.0.0.1:${DOSE_PORT:-8080}/" -o /dev/null
docker image inspect dose-site:local \
  --format 'image={{.Id}} user={{.Config.User}} ports={{json .Config.ExposedPorts}}'
```

### Diagnose build or runtime errors

```bash
# Show full build output and bypass cached build layers
docker compose --progress=plain build --pull --no-cache site

# Review recent timestamped logs, or follow new log entries
docker compose logs --tail=200 --timestamps site
docker compose logs --follow --since=10m site

# Inspect the last health-check results and container exit state
docker inspect --format \
  'state={{json .State}} health={{if .State.Health}}{{json .State.Health.Log}}{{else}}not-configured{{end}}' \
  "$(docker compose ps --all -q site)"
```

An empty container ID means the service has not been created yet; run
`docker compose up -d` before using `exec` or container inspection commands.

### Container actions

```bash
docker compose restart site       # Restart the running service
docker compose stop site          # Stop without removing it
docker compose start site         # Start a stopped service
docker compose down               # Stop and remove the preview container/network
```

## Local development

Install Zola, then run `zola serve` to preview local changes. Docker builds the
published site from remote `main`, not from the local content or templates.
Write articles as Markdown files in `content/`. The site's colors, typography,
and layout are defined in `sass/style.scss`; author details and optional
contact links are configured in `config.toml`.
