import express from 'express'
import mysql from 'mysql2'
import cors from 'cors'
import dotenv from 'dotenv'

dotenv.config()

const app = express()
app.use(cors())
app.use(express.json())

// Adatbázis kapcsolat
const db = mysql.createConnection({
  host: process.env.DB_HOST,
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  database: process.env.DB_NAME,
  port: process.env.DB_PORT
})

db.connect(err => {
  if (err) {
    console.error('Adatbázis hiba:', err)
    return
  }
  console.log('Adatbázis csatlakozva')
})

// TESZT végpont
app.get('/api/users', (req, res) => {
  db.query('SELECT * FROM users', (err, results) => {
    if (err) {
      return res.status(500).json({ error: err })
    }
    res.json(results)
  })
})

app.listen(process.env.PORT, () => {
  console.log(`Szerver fut: http://localhost:${process.env.PORT}`)
})
