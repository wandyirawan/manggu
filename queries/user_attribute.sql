-- name: GetUserAttributes :many
SELECT user_id, key, value, created_at, updated_at
FROM user_attributes
WHERE user_id = ?;

-- name: SetUserAttribute :exec
INSERT OR REPLACE INTO user_attributes (user_id, key, value, created_at, updated_at)
VALUES (?, ?, ?, ?, ?);

-- name: DeleteUserAttribute :exec
DELETE FROM user_attributes
WHERE user_id = ? AND key = ?;

-- name: DeleteAllUserAttributes :exec
DELETE FROM user_attributes
WHERE user_id = ?;

