const express = require('express');
const bodyParser = require('body-parser');
const { Pool } = require('pg');
const app = express();
const port = process.env.PORT || 4040;

const pool = new Pool({
  user: 'postgres',
  host: 'localhost',
  database: 'Detail',
  password: '1057',
  port: 5432,
});

app.use(bodyParser.json());

// Test database connection
pool.connect((err, client, release) => {
  if (err) {
    console.error('Error acquiring client', err.stack);
  } else {
    console.log('Database connected successfully');
  }
  release();
});

app.get('/product/:barcode', async (req, res) => {
  const { barcode } = req.params;
  try {
    const result = await pool.query('SELECT * FROM products WHERE barcode = $1', [barcode]);
    if (result.rows.length > 0) {
      res.json(result.rows[0]);
    } else {
      res.status(404).send('Product not found');
    }
  } catch (error) {
    res.status(500).send(error.message);
  }
});

app.post('/product', async (req, res) => {
  const { name, barcode, purchase_price, selling_price } = req.body;
  try {
    const result = await pool.query(
      'INSERT INTO products (name, barcode, purchase_price, selling_price) VALUES ($1, $2, $3, $4)',
      [name, barcode, purchase_price, selling_price]
    );
    res.status(201).json(result.rows[0]);
  } catch (error) {
    res.status(500).send(error.message);
  }
});

// Add DELETE endpoint
app.delete('/product/:id', async (req, res) => {
  const { id } = req.params;
  try {
    const result = await pool.query('DELETE FROM products WHERE id = $1 RETURNING *', [id]);
    if (result.rows.length > 0) {
      res.json(result.rows[0]);
    } else {
      res.status(404).send('Product not found');
    }
  } catch (error) {
    res.status(500).send(error.message);
  }
});

app.listen(port, () => {
  console.log(`Server running on port ${port}`);
});
