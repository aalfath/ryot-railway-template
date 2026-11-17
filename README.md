[![Deploy on Railway](https://railway.com/button.svg)](https://railway.com/new/template/ryot?utm_medium=integration&utm_source=button&utm_campaign=ryot)

# Ryot on Railway

A one-click [Railway](https://railway.com) template for [Ryot](https://github.com/IgnisDa/ryot), the self-hosted tracker for movies, shows, books, games, podcasts, anime, manga and workouts.

## What it deploys

| Service | Source | Notes |
|---|---|---|
| `Ryot` | this repo (`Dockerfile`) | `ghcr.io/ignisda/ryot:v10.5.8`, pinned by digest. Public domain, health check `/health`, port `8000` |
| `Postgres` | Railway Postgres | All Ryot data lives here, on a Railway volume. Reached over the private network |

Ryot keeps all of its state in Postgres, so the Ryot service itself needs no volume. File uploads (avatars, workout photos) only work after you connect S3-compatible storage (see below).

## Variables

| Variable | Default | Why |
|---|---|---|
| `DATABASE_URL` | `${{Postgres.DATABASE_URL}}` | Private-network connection to the bundled Postgres |
| `SERVER_ADMIN_ACCESS_TOKEN` | `${{secret(32)}}` | Admin API token, generated per deploy |
| `FRONTEND_URL` | `https://${{RAILWAY_PUBLIC_DOMAIN}}` | Base URL for links Ryot generates |
| `PORT` | `8000` | Port of Ryot's built-in proxy |
| `TZ` | `Etc/UTC` | Time zone for scheduled jobs (optional) |

The deploy asks for nothing. After it's up, open the public URL and register: the first account you create becomes the admin. Then, if you don't want anyone else to sign up, set `USERS_ALLOW_REGISTRATION=false` on the Ryot service.

Optional, set on the Ryot service when you need them (see [Ryot's configuration docs](https://docs.ryot.io/configuration)):

- `MOVIES_AND_SHOWS_TMDB_ACCESS_TOKEN`: movies and shows search (TMDB).
- `VIDEO_GAMES_TWITCH_CLIENT_ID` and `VIDEO_GAMES_TWITCH_CLIENT_SECRET`: video games (IGDB).
- `FILE_STORAGE_S3_*`: S3-compatible storage for uploads, for example a Railway bucket.
- `DISABLE_TELEMETRY=true`: turns off Ryot's anonymous usage statistics.
- `SERVER_SMTP_*`, `SERVER_OIDC_*`: email and single sign-on.

## Updates

The Ryot service builds from this repository. When a new Ryot version is out, this repo's `Dockerfile` gets the new pinned image and a `CHANGELOG.md` entry, and Railway shows an "update available" notice on your project. Read the [CHANGELOG](CHANGELOG.md) first, then apply the update from the Railway dashboard. Ryot runs its database migrations on start.

## Local run

```sh
docker build -t ryot-railway .
docker run --rm -p 8000:8000 -e DATABASE_URL=postgres://USER:PASSWORD@HOST:5432/DB -e SERVER_ADMIN_ACCESS_TOKEN=$(openssl rand -hex 16) ryot-railway
```

Ryot is GPL-3.0 software by [IgnisDa](https://github.com/IgnisDa). This repository only holds the Railway packaging.
