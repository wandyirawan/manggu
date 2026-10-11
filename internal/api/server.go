package api

import (
	"log/slog"
	"net/http"

	"manggu/internal/db"
)

type Server struct {
	db  *db.Queries
	cfg Config
	log *slog.Logger
}

func NewServer(db *db.Queries, cfg Config, log *slog.Logger) *Server {
	return &Server{db: db, cfg: cfg, log: log}
}

func (s *Server) Routes() http.Handler {
	mux := http.NewServeMux()
	mux.HandleFunc("GET /healthz", s.HandlerHealth)
	return s.logMiddleware(mux)
}
