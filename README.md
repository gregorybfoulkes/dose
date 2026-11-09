# Greg

A quiet personal site for writing, built with [Zola](https://www.getzola.org/).

## Docker preview

Build and start the latest site from the remote `main` branch:

```bash
docker compose up --build -d
```

Open [http://localhost:8080](http://localhost:8080). The container runs Nginx
as an unprivileged user, exposes the service only on localhost, and has a
read-only filesystem with a health check. Set `DOSE_PORT` to use another local
port:

```bash
DOSE_PORT=8081 docker compose up --build -d
```

Check container health and view logs with:

```bash
docker compose ps
docker compose logs -f site
```

Stop the preview with `docker compose down`.

## Local development

Install Zola, then run `zola serve` to preview local changes. Docker builds the
published site from remote `main`, not from the local content or templates.
Write articles as Markdown files in `content/`. The site's colors, typography,
and layout are defined in `sass/style.scss`; author details and optional
contact links are configured in `config.toml`.
