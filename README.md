# ClassRegister

A Rails application for tracking magic classes: the chapters (locations) where classes run, the
teachers who run them, the students who attend, a register for each session with audio and photo
attachments, and a per-student record of attendance and points.

See [docs/application-overview.md](docs/application-overview.md) for a full description,
[docs/database-schema.md](docs/database-schema.md) for the data model, and
[docs/upgrade-notes.md](docs/upgrade-notes.md) for the Ruby 4 / Rails 8 upgrade.

## Stack

| | |
|---|---|
| Ruby | 4.0.6 |
| Rails | 8.1.3.1 |
| Database | PostgreSQL 18 (all environments) |
| Assets | Sprockets + Turbo |

## Getting started

You need Ruby 4.0.6 and Docker (for the local database).

```bash
bundle install
docker compose up -d db
bin/rails db:create db:migrate
bin/rails server
```

The app is then on http://localhost:3000.

### The database

PostgreSQL runs in Docker via [docker-compose.yml](docker-compose.yml), because Ubuntu 20.04's apt
only offers PostgreSQL 12, which is end-of-life.

```bash
docker compose up -d db     # start
docker compose down         # stop, keeping data
docker compose down -v      # stop and DELETE all local data
```

Connection settings default to `class_register` / `class_register` on `localhost:5432` and can be
overridden with `DATABASE_HOST`, `DATABASE_PORT`, `DATABASE_USERNAME`, `DATABASE_PASSWORD` and
`DATABASE_NAME`. In production, a `DATABASE_URL` overrides all of them.

To rebuild from scratch:

```bash
bin/rails db:drop db:create db:migrate
```

### Ruby

Ruby 4.0.6 is managed by RVM, but note that **RVM 1.29.12 cannot install Ruby 4 unaided** — this
one was finished by hand. `.ruby-version` must keep the `ruby-4.0.6` form (not a bare `4.0.6`),
or RVM's directory auto-switching will not recognise it. See
[docs/upgrade-notes.md](docs/upgrade-notes.md) section 2 before adding another Ruby.

#### "Your Ruby version is 3.3.4, but your Gemfile specified 4.0.6"

This was an environment problem, now fixed in `~/.bashrc`. Recorded here in case it comes back or
happens on another machine.

RVM is installed system-wide and is only wired up by `/etc/profile.d/rvm.sh`, which bash runs for
**login** shells. An interactive non-login shell — a new WSL terminal, a tmux pane, an editor's
integrated terminal — never loaded it. In that state `cd` was the plain builtin rather than RVM's
wrapper, so RVM's directory hook never fired and `.ruby-version` was ignored, while PATH still
pointed at RVM's *default* ruby. Note that `rvm use` did not help either, because `rvm` was not
even defined as a function in those shells.

Two lines were appended to `~/.bashrc` (they must stay at the end, since RVM prepends to PATH):

```bash
[[ -s "/usr/share/rvm/scripts/rvm" ]] && source "/usr/share/rvm/scripts/rvm"
[[ -s "$PWD/.ruby-version" ]] && cd .
```

The first loads RVM so the `cd` hook exists. The second is needed because RVM only applies
`.ruby-version` *on a cd* — it does not evaluate the directory a shell starts in — so it triggers
the hook once for the starting directory.

rbenv and mise avoid this whole class of problem, because they use shims that resolve the version
when a command actually runs rather than relying on a shell hook.

## Known limitations

- **No authentication.** Every page and JSON endpoint is world-readable and world-writable. Do not
  expose this to the internet as-is — it holds children's names and birth dates.
- **Image thumbnails are disabled.** Active Storage 8.1 will not boot against this host's libvips
  8.9.1, so `image_processing` is commented out and images render at full size, capped with CSS.
  See [docs/upgrade-notes.md](docs/upgrade-notes.md) section 5.
- **Audio recording does not work.** The register form loads Recorder.js from `cdn.rawgit.com`,
  which shut down in 2019. The library needs vendoring.
- **Attachments are stored on local disk** (`config.active_storage.service = :local`), including
  in production. On an ephemeral-filesystem host such as Heroku or DigitalOcean App Platform,
  uploads would be destroyed on every deploy — move to S3 or Spaces before deploying there.
- **The test suite is empty scaffold stubs.**
