# Upgrade: Rails 5.2 / Ruby 2.5 → Rails 8.1 / Ruby 4.0

Record of the upgrade performed on 2026-08-25, what changed, and what still needs a decision.

See [application-overview.md](application-overview.md) for what the application does and
[database-schema.md](database-schema.md) for the schema.

---

## 1. Result

| | Before | After |
|---|---|---|
| Ruby | 2.5.1 | **4.0.6** |
| Rails | 5.2.3 | **8.1.3.1** |
| Bundler | 1.16.2 | 4.0.16 |
| `config.load_defaults` | 5.2 | 8.1 |
| Database (dev/test) | SQLite | **PostgreSQL 18** |
| Database (production) | PostgreSQL (unconfigured) | **PostgreSQL** (configured) |

The application **runs**. All nine migrations are applied against PostgreSQL 18.6, every page
returns 200, and a create/destroy round-trip through the web forms works. `bundle install`
completes with 88 gems.

---

## 2. Installing Ruby 4.0.6 — read this before adding another Ruby

The RVM installation on this machine is **1.29.12, which is the newest release RVM has ever
made** (upstream `master` is `1.29.12-next` and effectively dormant). It predates Ruby 4
entirely, and this causes two distinct problems:

1. **Its version parser rejects a bare `4.0.6`.** `rvm use 4.0.6` fails with "Unknown ruby
   interpreter version". The prefixed form, `rvm use ruby-4.0.6`, parses fine. **This is why
   `.ruby-version` contains `ruby-4.0.6` and not `4.0.6`** — the bare form would break RVM's
   directory auto-switching.

2. **`rvm install ruby-4.0.6` downloads and compiles, but does not finish.** It fetched the
   tarball to `/usr/share/rvm/archives`, extracted to `/usr/share/rvm/src/ruby-4.0.6`, configured
   with the correct prefix and started compiling — then died before creating the per-ruby gemset
   scaffolding, leaving a half-installed ruby that `rvm list` displayed but `rvm use` rejected as
   "not installed".

The install was completed by hand:

```bash
# finish the compile RVM started
cd /usr/share/rvm/src/ruby-4.0.6 && make -j8 && make install

# create the gemset scaffolding RVM never got to
mkdir -p /usr/share/rvm/gems/ruby-4.0.6/bin \
         /usr/share/rvm/gems/ruby-4.0.6@global/bin \
         /usr/share/rvm/wrappers/ruby-4.0.6 \
         /usr/share/rvm/wrappers/ruby-4.0.6@global
# plus /usr/share/rvm/environments/ruby-4.0.6 and ...@global,
# copied from the ruby-3.3.4 equivalents with the version string swapped
```

These changes are **purely additive** — only files for `ruby-4.0.6` were created, and the
existing 3.0.3 / 3.2.2 / 3.3.4 installs were not touched.

`rvm ruby-4.0.6 do <cmd>` now works, `Gem.dir` resolves to
`/usr/share/rvm/gems/ruby-4.0.6`, and bundler 4.0.16 is available.

**Recommendation:** RVM is a dead project and will need this hand-patching for every future Ruby.
Consider moving to [mise](https://mise.jdx.dev/) or rbenv, both of which are actively maintained
and handle Ruby 4.x natively. They coexist with RVM, so the migration can be done one project at
a time.

### Build notes

Ruby 4.0.6 compiled cleanly against the system OpenSSL 1.1.1f on Ubuntu 20.04 — `openssl`,
`psych`, `zlib` and `net/https` all load. No custom OpenSSL build was needed.

---

## 3. Gem changes

| Gem | Before | After | Why |
|---|---|---|---|
| `rails` | ~> 5.2.3 | **~> 8.1.3** (8.1.3.1) | the upgrade |
| `sass-rails` | ~> 5.0 | **removed** | depends on the dead Ruby Sass. Only `scaffolds.scss` used any Sass syntax (two levels of `&` nesting), so the stylesheets were converted to plain CSS and the dependency dropped rather than replaced with `dartsass-sprockets`. Add that gem back if you want to write Sass again. |
| `uglifier` | >= 1.3.0 | **`terser` 1.2.8** | uglifier cannot parse ES6; terser is the drop-in successor |
| `coffee-rails` | ~> 4.2 | **removed** | no longer part of Rails, and all five `.coffee` files in this app were empty generator stubs containing only comments |
| `turbolinks` | ~> 5 | **`turbo-rails` 2.0.23** | turbolinks is end-of-life; Turbo is its successor |
| `sprockets-rails` | (implicit) | **3.5.2, explicit** | Rails 8 defaults to Propshaft. This app uses Sprockets manifest directives (`//= require`, `require_tree`), which Propshaft does not support, so Sprockets is now declared explicitly rather than relying on a default that no longer exists. |
| `chromedriver-helper` | present | **removed** | yanked from RubyGems in 2020; Selenium 4 manages its own drivers |
| `spring`, `spring-watcher-listen` | present | **removed** | dropped from Rails defaults in 7.0; `bin/spring` and `config/spring.rb` deleted |
| `listen` | >= 3.0.5, < 3.2 | **removed** | only needed for the evented file watcher, which the regenerated development config no longer sets |
| `byebug` | present | **`debug` 1.11.1** | byebug is superseded by the `debug` gem that now ships with Ruby |
| `puma` | ~> 3.11 | **>= 6.0** (8.0.2) | Rails 8 requires Puma 5+ |
| `sqlite3` | dev/test | **removed** | development and test moved to PostgreSQL, see section 6 |
| `pg` | production only | **~> 1.5 (1.6.3), all environments** | promoted out of the `:production` group so dev/test/production share one engine |
| `image_processing`, `mini_magick` | present | **commented out** | see section 5 — this is the one open decision |

---

## 4. Application code changes

**`config/application.rb`** — `config.load_defaults` 5.2 → 8.1, and `config.autoload_lib` added by
the generator. Note that jumping the defaults in one step changes the key generator digest to
SHA-256, which **invalidates any existing signed or encrypted cookies**. For this application that
is harmless: there is no authentication and nothing durable is stored in the session.

**`config/database.yml`** — the `production:` key previously contained *only comments*: no
adapter, no database, no URL. Under Rails 8.1 this is a hard error, and not just in production —
Active Record validates every environment's configuration when it loads its rake tasks, so the
empty block broke `rails` commands in development too.

It is now PostgreSQL in **every** environment, driven by environment variables, with
`DATABASE_URL` taking precedence in production. The previous SQLite-dev / Postgres-production
split is gone; see section 6.

**Controllers (all five)** — `status: :unprocessable_entity` → `status: :unprocessable_content`.
This is not cosmetic. Rack 3 renamed the 422 symbol and **removed the old name**, so the existing
JSON error branches would have raised `ArgumentError` at runtime on any validation failure.

The HTML branches also gained `status: :unprocessable_content` on `render :new` / `render :edit`.
Turbo ignores a 200 response to a form submission, so without an error status the form would
silently do nothing instead of showing validation messages.

**Views** — the five `Destroy` links used rails-ujs syntax
(`method: :delete, data: { confirm: ... }`). They now use Turbo's
`data: { turbo_method: :delete, turbo_confirm: ... }`. The layout's `data-turbolinks-track`
became `data-turbo-track`.

**`app/assets/javascripts/application.js`** — `//= require turbolinks` → `//= require turbo`, and
`//= require rails-ujs` dropped. Action View does still ship rails-ujs, but running it alongside
Turbo causes double-handled events, and Turbo covers everything this app used it for.

**Stylesheets** — the five empty `.scss` stubs and `scaffolds.scss` became `.css`. The only real
Sass in the project was `&:visited` / `&:hover` on `a`, `&.field, &.actions` on `div`, and two
nested rules under `#error_explanation`; all were flattened by hand.

**Deleted** — five empty `.coffee` stubs, `bin/spring`, `bin/update`, `bin/yarn`,
`config/spring.rb`.

**Regenerated by `rails app:update`** — `bin/rails`, `bin/rake`, `bin/setup`, `config/boot.rb`,
`config/environment.rb`, all three `config/environments/*.rb`, several initializers,
`config/puma.rb`, and the static `public/*.html` error pages. New files: `bin/ci`, `bin/dev`,
`config/ci.rb`, `config/initializers/new_framework_defaults_8_1.rb`, `public/icon.svg`.

---

## 5. Image variants are disabled (deliberately, for now)

Thumbnails on the classroom-register show page are switched off, by decision, to get the
application running without fighting the host's libvips.

**Why:** Active Storage 8.1 refuses to boot when `ruby-vips` is loadable but the system libvips is
older than 8.13, because it cannot call `Vips.block_untrusted(true)` and will not process
untrusted uploads with libvips' unfuzzed operations. It raises at require time. This host has
libvips **8.9.1** and Ubuntu 20.04's archive has nothing newer. `image_processing` hard-depends on
`ruby-vips`, so it cannot be kept without dragging the failure in. ImageMagick is not installed
either, so the `mini_magick` backend has no binary — **no variant processor could work here in any
case.**

**What was changed:** `image_processing` and `mini_magick` are commented out of the `Gemfile`, and
`app/views/classroom_registers/show.html.erb` now renders images at full size, capped with CSS:

```erb
<%= image_tag url_for(file), style: "max-width: 100px; max-height: 100px;" %>
```

The `file.variant(resize_to_limit: [100, 100])` call it replaced is preserved in an ERB comment
right above it, with restore instructions.

Note the original line it replaced, `<!-- <%= image_tag url_for(file) %> -->`, was only an *HTML*
comment — ERB still evaluated it and emitted the tag inside a comment, so both were running. The
replacement uses a real ERB comment (`<%# ... %>`), which does not execute.

**To restore thumbnails:** install libvips >= 8.13 (a PPA or source build on 20.04; Ubuntu 24.04
ships 8.15.1 from the archive), uncomment the two gems, `bundle install`, and swap the view line
back.

---

## 6. The database — PostgreSQL everywhere

Development and test were moved off SQLite so that every environment runs the same engine. `pg` is
now a top-level dependency rather than production-only, and `sqlite3` is gone.

**Local server:** there was no PostgreSQL server on this machine at all — only `pg_config` from
`libpq-dev`, which is what let the `pg` gem compile. Ubuntu 20.04's apt only offers PostgreSQL 12
(EOL since November 2024), so a `docker-compose.yml` was added instead, running **PostgreSQL 18**:

```bash
docker compose up -d db     # start
docker compose down         # stop, keeping data
docker compose down -v      # stop and delete all local data
```

Credentials are `class_register` / `class_register` on `localhost:5432`, overridable via
`DATABASE_HOST` / `DATABASE_PORT` / `DATABASE_USERNAME` / `DATABASE_PASSWORD` / `DATABASE_NAME`.
In production a `DATABASE_URL` takes precedence over all of them.

### The schema had to be rebuilt from the migrations

Worth knowing, because it is a subtle trap. Running `rails db:migrate` against the new empty
Postgres database did **not** run the original five migrations — Rails found `db/schema.rb`,
loaded it, and then applied only the three new Active Storage migrations on top.

That mattered because `db/schema.rb` had been generated from **SQLite**, which does not
round-trip `foreign_key: true` and reports reference columns as `integer`. The resulting Postgres
database had `integer` foreign-key columns pointing at `bigint` primary keys, and **not one of the
seven foreign key constraints the migrations declare**.

The fix was to move `db/schema.rb` aside and re-run `db:drop db:create db:migrate`, so the
migrations actually executed. The database now has `bigint` reference columns and all seven
constraints, and `db/schema.rb` has been regenerated from PostgreSQL — it is now the Postgres
schema and includes the `add_foreign_key` lines.

**Consequence for any existing data:** foreign keys are now enforced. Rows with a dangling
`chapter_id`, `teacher_id` or `student_id` will be rejected on import.

### Migration state

All nine migrations are applied:

| Version | Migration |
|---|---|
| `20190803005755` … `20190803010817` | the five original table migrations |
| `20190809214144` | `CreateActiveStorageTables` |
| `20260826014950` | `AddServiceNameToActiveStorageBlobs` |
| `20260826014951` | `CreateActiveStorageVariantRecords` |
| `20260826014952` | `RemoveNotNullOnActiveStorageBlobsChecksum` |

`ActiveRecord::Migration[5.2]` still resolves under Rails 8.1, so the five original migrations
needed no edits. The three Active Storage migrations are *additive* — the original
`20190809214144` was deliberately left in place rather than replaced, so an existing production
database only needs the three new ones applied.

To rebuild from scratch at any time:

```bash
docker compose up -d db && bin/rails db:drop db:create db:migrate
```

---

## 7. Other pre-existing problems

These were found while reading the code and are unrelated to the version bump. The ones that
stopped the app from working were fixed while getting it running; the rest are listed so they are
not forgotten.

- ~~**The audio player condition is inverted.**~~ **FIXED.** `show.html.erb` used
  `unless @classroom_register.audio.attached?`, so the player rendered only when there was *no*
  audio, and `rails_blob_url` on an unattached attachment raises — meaning the show page errored
  for every register without a recording. Now `if`.
- **The Recorder.js CDN is dead — STILL OPEN.** The register form loads Recorder.js from
  `cdn.rawgit.com`, which shut down in October 2019, so `Recorder` is undefined and the record
  button does nothing. This was left alone deliberately rather than silently repointing you at a
  different third party. Two options: vendor the file into `vendor/assets/javascripts/`
  (preferred — no third-party dependency, works with CSP), or point the `<script>` tag at jsDelivr
  using the same pinned commit.
- ~~**`recording_audio.js` throws on every page.**~~ **FIXED.** It is bundled by `require_tree .`
  so it runs everywhere, and it called `addEventListener` on a null `#recordButton`, aborting the
  script on every page without the widget. It now returns early when the buttons are absent, and
  binds to `turbo:load` as well as `DOMContentLoaded` (Turbo does not fire the latter on
  client-side visits). It also warns and bails if `Recorder` is undefined — which it currently is,
  see the next item.
- **No authentication or authorization — STILL OPEN, and the most important item here.** Every
  route, HTML and JSON alike, is world-readable and world-writable, over data that includes
  children's names and birth dates. This needs solving before the app is reachable from the public
  internet.
- ~~**No root route.**~~ **FIXED.** `/` now maps to `chapters#index`. That was a guess at a
  sensible landing page — change it in `config/routes.rb` if you'd rather land elsewhere.
- **The test suite is empty generator stubs — STILL OPEN.** There is no regression safety net for
  this upgrade. Verification was done by hand: every index, show, edit and `new` page returns 200,
  a create and a destroy round-trip through the forms both work, `zeitwerk:check` passes, assets
  precompile, and the server log is free of errors and deprecation warnings.
