require('dotenv').config();
const express = require('express');
const cors = require('cors');
const { Pool } = require('pg');

const app = express();
const port = process.env.PORT || 3000;

app.use(cors());
app.use(express.json({ limit: '10mb' }));

const pool = new Pool({ connectionString: process.env.DATABASE_URL });

function rowToItem(row) {
  return {
    id: row.id,
    name: row.name,
    type: row.type,
    colors: row.colors,
    styles: row.styles,
    imageBytes: row.image_base64,
  };
}

app.get('/health', async (_req, res) => {
  try {
    await pool.query('SELECT 1');
    res.json({ ok: true });
  } catch (error) {
    res.status(500).json({ ok: false, error: error.message });
  }
});

app.get('/closet', async (_req, res) => {
  try {
    const { rows } = await pool.query(
      `SELECT id, name, type, colors, styles, image_base64
       FROM clothing_items
       ORDER BY created_at`
    );
    res.json(rows.map(rowToItem));
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

app.post('/closet/items', async (req, res) => {
  const { id, name, type, colors, styles, imageBytes } = req.body;

  if (!id || !name || !type) {
    return res.status(400).json({ error: 'id, name and type are required' });
  }

  try {
    await pool.query(
      `INSERT INTO clothing_items (id, name, type, colors, styles, image_base64)
       VALUES ($1, $2, $3, $4, $5, $6)
       ON CONFLICT (id) DO UPDATE SET
         name = EXCLUDED.name,
         type = EXCLUDED.type,
         colors = EXCLUDED.colors,
         styles = EXCLUDED.styles,
         image_base64 = EXCLUDED.image_base64`,
      [id, name, type, colors ?? [], styles ?? [], imageBytes ?? null]
    );
    res.status(201).send();
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

app.put('/closet', async (req, res) => {
  const items = req.body;

  if (!Array.isArray(items)) {
    return res.status(400).json({ error: 'Body must be an array of clothing items' });
  }

  const client = await pool.connect();
  try {
    await client.query('BEGIN');
    await client.query('DELETE FROM clothing_items');

    for (const item of items) {
      await client.query(
        `INSERT INTO clothing_items (id, name, type, colors, styles, image_base64)
         VALUES ($1, $2, $3, $4, $5, $6)`,
        [
          item.id,
          item.name,
          item.type,
          item.colors ?? [],
          item.styles ?? [],
          item.imageBytes ?? null,
        ]
      );
    }

    await client.query('COMMIT');
    res.send();
  } catch (error) {
    await client.query('ROLLBACK');
    res.status(500).json({ error: error.message });
  } finally {
    client.release();
  }
});

app.listen(port, () => {
  console.log(`API running on http://localhost:${port}`);
});
