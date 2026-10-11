package main

import (
	"log/slog"
	"net/http"
	"os"
	"time"

	"manggu/internal/api"
	"manggu/internal/db"
)

func main() {
	cfg := api.LoadConfig()

	var logger *slog.Logger
	if cfg.DevMode {
		logger = slog.New(slog.NewTextHandler(os.Stdout, &slog.HandlerOptions{Level: slog.LevelDebug}))
	} else {
		logger = slog.New(slog.NewJSONHandler(os.Stdout, nil))
	}

	pool, err := OpenDB(cfg.DatabaseURL)
	if err != nil {
		logger.Error("db connection failed", "err", err)
		os.Exit(1)
	}
	defer pool.Close()

	srv := api.NewServer(db.New(pool), cfg, logger)

	httpSrv := &http.Server{
		Addr:         cfg.Addr,
		Handler:      srv.Routes(),
		ReadTimeout:  10 * time.Second,
		WriteTimeout: 30 * time.Second,
	}

	logger.Info("server running", "addr", "http://localhost"+cfg.Addr)
	if err := httpSrv.ListenAndServe(); err != nil && err != http.ErrServerClosed {
		logger.Error("server exited", "err", err)
		os.Exit(1)
	}
}
