package api

import (
	"os"
)

type Config struct {
	Addr        string
	DatabaseURL string
	LogLevel    string
	DevMode     bool
}

func LoadConfig() Config {
	cfg := Config{
		Addr:        getEnv("APP_ADDR", ":4001"),
		DatabaseURL: getEnv("MANGGU_DB_DSN", "file:./manggu.db"),
		LogLevel:    getEnv("LOG_LEVEL", "info"),
		DevMode:     os.Getenv("APP_ENV") != "production",
	}
	return cfg
}

func getEnv(key, fallback string) string {
	if v := os.Getenv(key); v != "" {
		return v
	}
	return fallback
}
