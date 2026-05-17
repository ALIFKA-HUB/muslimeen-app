const express = require('express');
const cors = require('cors');
const bcrypt = require('bcrypt');
const db = require('./db');

const app = express();
const PORT = 3000;
const SALT_ROUNDS = 10;

// ── Middleware ────────────────────────────────────────────────────────────────
app.use(cors());
app.use(express.json());

// ── Health check ──────────────────────────────────────────────────────────────
app.get('/', (req, res) => {
  res.json({
    status: 'ok',
    message: 'Muslimeen API is running 🌙',
    version: '1.0.0',
    endpoints: {
      register: 'POST /api/register',
      login: 'POST /api/login',
    },
  });
});

// ── POST /api/register ────────────────────────────────────────────────────────
app.post('/api/register', async (req, res) => {
  const { full_name, email, password } = req.body;

  // Validate input
  if (!full_name || !email || !password) {
    return res.status(400).json({
      success: false,
      message: 'full_name, email, dan password wajib diisi.',
    });
  }

  if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)) {
    return res.status(400).json({
      success: false,
      message: 'Format email tidak valid.',
    });
  }

  if (password.length < 6) {
    return res.status(400).json({
      success: false,
      message: 'Password minimal 6 karakter.',
    });
  }

  try {
    // Check if email already exists
    db.get('SELECT id FROM users WHERE email = ?', [email], async (err, row) => {
      if (err) {
        return res.status(500).json({ success: false, message: 'Database error.' });
      }
      if (row) {
        return res.status(409).json({
          success: false,
          message: 'Email sudah terdaftar. Silakan gunakan email lain.',
        });
      }

      // Hash password and insert user
      const hashedPassword = await bcrypt.hash(password, SALT_ROUNDS);

      db.run(
        'INSERT INTO users (full_name, email, password) VALUES (?, ?, ?)',
        [full_name, email, hashedPassword],
        function (err) {
          if (err) {
            return res.status(500).json({ success: false, message: 'Gagal membuat akun.' });
          }

          const userId = this.lastID;
          db.get('SELECT id, full_name, email, role FROM users WHERE id = ?', [userId], (err, user) => {
            if (err || !user) {
              return res.status(500).json({ success: false, message: 'Gagal mengambil data user.' });
            }
            return res.status(201).json({
              success: true,
              message: 'Akun berhasil dibuat. Ahlan wa sahlan! 🌙',
              user,
            });
          });
        }
      );
    });
  } catch (error) {
    console.error('Register error:', error);
    res.status(500).json({ success: false, message: 'Internal server error.' });
  }
});

// ── POST /api/login ───────────────────────────────────────────────────────────
app.post('/api/login', (req, res) => {
  const { email, password } = req.body;

  if (!email || !password) {
    return res.status(400).json({
      success: false,
      message: 'Email dan password wajib diisi.',
    });
  }

  db.get(
    'SELECT id, full_name, email, password, role FROM users WHERE email = ?',
    [email],
    async (err, user) => {
      if (err) {
        return res.status(500).json({ success: false, message: 'Database error.' });
      }
      if (!user) {
        return res.status(401).json({
          success: false,
          message: 'Email tidak ditemukan.',
        });
      }

      try {
        const passwordMatch = await bcrypt.compare(password, user.password);
        if (!passwordMatch) {
          return res.status(401).json({
            success: false,
            message: 'Kata sandi salah.',
          });
        }

        // Return user without password
        const { password: _, ...safeUser } = user;
        return res.status(200).json({
          success: true,
          message: 'Login berhasil. Marhaban! 🌙',
          user: safeUser,
        });
      } catch (error) {
        console.error('Login error:', error);
        return res.status(500).json({ success: false, message: 'Internal server error.' });
      }
    }
  );
});

// ── GET /api/doa (proxy to bypass CORS) ──────────────────────────────────────
app.get('/api/doa', async (req, res) => {
  try {
    const response = await fetch('https://doa-doa-api-ahmadramadhan.fly.dev/api');
    if (!response.ok) {
      return res.status(response.status).json({ success: false, message: 'Upstream API error.' });
    }
    const data = await response.json();
    res.json(data);
  } catch (error) {
    console.error('Doa proxy error:', error);
    res.status(502).json({ success: false, message: 'Gagal mengambil data doa dari API.' });
  }
});

// ── GET /api/hifz/:userId ─────────────────────────────────────────────────────
app.get('/api/hifz/:userId', (req, res) => {
  const { userId } = req.params;
  db.all(
    'SELECT * FROM hifz_progress WHERE user_id = ? ORDER BY id',
    [userId],
    (err, rows) => {
      if (err) return res.status(500).json({ success: false, message: 'Database error.' });
      res.json({ success: true, data: rows });
    }
  );
});

// ── POST /api/hifz ────────────────────────────────────────────────────────────
app.post('/api/hifz', (req, res) => {
  const { user_id, surah_name, progress } = req.body;
  if (!user_id || !surah_name) {
    return res.status(400).json({ success: false, message: 'user_id dan surah_name wajib diisi.' });
  }
  db.run(
    'INSERT INTO hifz_progress (user_id, surah_name, progress) VALUES (?, ?, ?)',
    [user_id, surah_name, progress ?? 0],
    function (err) {
      if (err) return res.status(500).json({ success: false, message: 'Gagal menyimpan data.' });
      res.status(201).json({ success: true, id: this.lastID });
    }
  );
});

// ── PUT /api/hifz/:id ─────────────────────────────────────────────────────────
app.put('/api/hifz/:id', (req, res) => {
  const { id } = req.params;
  const { progress } = req.body;
  db.run(
    'UPDATE hifz_progress SET progress = ? WHERE id = ?',
    [progress, id],
    function (err) {
      if (err) return res.status(500).json({ success: false, message: 'Gagal mengupdate data.' });
      res.json({ success: true, changes: this.changes });
    }
  );
});

// ── Start server ──────────────────────────────────────────────────────────────
app.listen(PORT, () => {
  console.log(`\n🌙 Muslimeen API Server`);
  console.log(`   Running on: http://localhost:${PORT}`);
  console.log(`   Database: muslimeen.sqlite\n`);
});
