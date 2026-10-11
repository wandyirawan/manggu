# manggu

Manggu (manggis dalam bahasa Sunda) adalah Identity & Access Management (IAM) service
yang ditulis ulang dari [mangosteen](https://github.com/wandyirawan/mangosteen) dengan
satu aturan main: **no framework, core idiomatic Go only** — stdlib `net/http`,
`database/sql`, dan sqlc. Nama dan arah project ini terinspirasi dari akar sang
author: orang Sunda.

## Kenapa refactor

mangosteen mengandalkan framework untuk routing, binding, dan middleware. manggu
membuktikan bahwa layanan IAM yang sama bisa dibangun hanya dengan standard library:

- `net/http.ServeMux` dengan method-based routing (`GET /healthz`) — tanpa chi/gorilla/fiber
- `database/sql` + [sqlc](https://sqlc.dev) untuk type-safe query dari SQL mentah
- `modernc.org/sqlite` — driver pure-Go, tanpa CGO
- `log/slog` untuk structured logging

## Struktur

```
manggu/
├── cmd/api/          # entry point: wiring config, db, server (tipis)
├── internal/
│   ├── api/          # HTTP layer: Server struct, Routes(), handlers, middleware
│   └── db/           # sqlc codegen — jangan edit manual
├── migration/        # schema SQL (sumber models.go)
├── queries/          # query berlabel (sumber *.sql.go)
└── sqlc.yaml         # konfigurasi sqlc
```

Konvensi: handler adalah method pada `Server` yang menerima dependency
(`*db.Queries`, config, logger) lewat constructor — tanpa variabel global.
Setelah mengubah `migration/` atau `queries/`, regenerate dengan `make sqlc`.

## Menjalankan

```bash
make run          # MANGGU_DB_DSN=file:./manggu.db go run ./cmd/api

curl http://localhost:4001/healthz
# {"status":"ok"}
```

Variabel environment:

| Env             | Default           | Keterangan                          |
|-----------------|-------------------|-------------------------------------|
| `APP_ADDR`      | `:4001`           | host:port                           |
| `MANGGU_DB_DSN` | `file:./manggu.db`| DSN sqlite                          |
| `LOG_LEVEL`     | `info`            | level log                           |
| `APP_ENV`       | `development`     | `production` = JSON log, bukan text |

## Perintah

```bash
make run      # jalankan dev server
make build    # compile ke bin/api
make test     # go test ./...
make vet      # go vet ./...
make sqlc     # regenerate internal/db dari migration + queries
```

## Roadmap

- [x] Project scaffold: stdlib router, sqlc, structured logging
- [x] Health check endpoint
- [ ] User registration + password hashing
- [ ] Login → access token (JWT) + refresh token
- [ ] Refresh token rotation & revocation (query sudah siap)
- [ ] User attributes
- [ ] Middleware auth + rate limiting
- [ ] Integration tests
