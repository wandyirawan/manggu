-- name: CreateRefreshToken :exec
INSERT INTO refresh_tokens (id, user_id, token_hash, expires_at, revoked, created_at)
VALUES (?, ?, ?, ?, ?, ?);

-- name: GetRefreshToken :one
SELECT id, user_id, token_hash, expires_at, revoked, created_at
FROM refresh_tokens
WHERE id = ? AND revoked = 0;

-- name: RevokeRefreshToken :exec
UPDATE refresh_tokens
SET revoked = 1
WHERE id = ?;

-- name: RevokeAllUserTokens :exec
UPDATE refresh_tokens
SET revoked = 1
WHERE user_id = ?;

-- name: GetRefreshTokenByHash :one
SELECT id, user_id, token_hash, expires_at, revoked, created_at
FROM refresh_tokens
WHERE token_hash = ? AND revoked = 0;


