CREATE EXTENSION IF NOT EXISTS "pgcrypto";

CREATE TABLE IF NOT EXISTS clothing_items (
  id            TEXT PRIMARY KEY,
  name          TEXT NOT NULL,
  type          TEXT NOT NULL CHECK (type IN ('top', 'bottom', 'shoes', 'outerwear')),
  colors        TEXT[] NOT NULL DEFAULT '{}',
  styles        TEXT[] NOT NULL DEFAULT '{}',
  image_base64  TEXT,
  created_at    TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_clothing_items_type ON clothing_items (type);
