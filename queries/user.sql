-- name: CreateUser :exec
INSERT INTO users (id, email, password_hash, role, active, created_at, updated_at)
VALUES (?, ?, ?, ?, ?, ?, ?);

-- name: GetUserByID :one
SELECT id, email, password_hash, role, active, created_at, updated_at
FROM users
WHERE id = ?;

-- name: GetUserByEmail :one
SELECT id, email, password_hash, role, active, created_at, updated_at
FROM users
WHERE email = ?;

-- name: ListActiveUsers :many
SELECT id, email, password_hash, role, active, created_at, updated_at
FROM users
WHERE active = 1;

-- name: ListAllUsers :many
SELECT id, email, password_hash, role, active, created_at, updated_at
FROM users;

-- name: UpdateUser :exec
UPDATE users
SET email = ?, password_hash = ?, role = ?, active = ?, updated_at = ?
WHERE id = ?;

-- name: SoftDeleteUser :exec
UPDATE users
SET active = 0, updated_at = ?
WHERE id = ?;

-- name: ActivateUser :exec
UPDATE users
SET active = 1, updated_at = ?
WHERE id = ?;

-- name: HardDeleteUser :exec
DELETE FROM users
WHERE id = ?;


