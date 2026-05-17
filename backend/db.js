const sqlite3 = require('sqlite3').verbose();
const path = require('path');

const DB_PATH = path.join(__dirname, 'muslimeen.sqlite');

const db = new sqlite3.Database(DB_PATH, (err) => {
  if (err) {
    console.error('❌ Failed to connect to SQLite:', err.message);
  } else {
    console.log('✅ Connected to muslimeen.sqlite');
    initTables();
  }
});

function initTables() {
  db.serialize(() => {
    // users table
    db.run(`
      CREATE TABLE IF NOT EXISTS users (
        id       INTEGER PRIMARY KEY AUTOINCREMENT,
        full_name TEXT NOT NULL,
        email    TEXT NOT NULL UNIQUE,
        password TEXT NOT NULL,
        role     TEXT NOT NULL DEFAULT 'user',
        created_at DATETIME DEFAULT CURRENT_TIMESTAMP
      )
    `, (err) => {
      if (err) console.error('Error creating users table:', err.message);
      else console.log('✅ Table: users ready');
    });

    // hifz_progress table
    db.run(`
      CREATE TABLE IF NOT EXISTS hifz_progress (
        id         INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id    INTEGER NOT NULL,
        surah_name TEXT NOT NULL,
        progress   INTEGER NOT NULL DEFAULT 0,
        created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
      )
    `, (err) => {
      if (err) console.error('Error creating hifz_progress table:', err.message);
      else console.log('✅ Table: hifz_progress ready');
    });
  });
}

module.exports = db;
