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
    hasImage: Boolean(row.has_image),
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
      `SELECT id, name, type, colors, styles,
              (image_base64 IS NOT NULL AND image_base64 <> '') AS has_image
       FROM clothing_items
       ORDER BY created_at`
    );
    res.json(rows.map((row) => rowToItem(row)));
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

app.get('/closet/items/:id/image', async (req, res) => {
  try {
    const { rows } = await pool.query(
      `SELECT image_base64 FROM clothing_items WHERE id = $1`,
      [req.params.id]
    );
    if (!rows[0]?.image_base64) {
      return res.status(404).json({ error: 'Image not found' });
    }
    res.json({ imageBytes: rows[0].image_base64 });
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

app.listen(port, () => {
  console.log(`API running on http://localhost:${port}`);
});
