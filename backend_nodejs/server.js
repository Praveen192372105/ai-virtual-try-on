// ============================================================
// server.js — Node.js Express Server Entry Point
// AI-Based Virtual Try-On Application
// ============================================================
// PURPOSE:
//   Bootstraps the Express.js server. Loads environment vars,
//   connects to MongoDB, registers middleware and route handlers,
//   and starts listening on the configured port.
//
// RUN:   node server.js  OR  npm run dev (with nodemon)
// ============================================================

require('dotenv').config(); // Load .env variables FIRST

const express    = require('express');
const mongoose   = require('mongoose');
const cors       = require('cors');
const helmet     = require('helmet');
const morgan     = require('morgan');
const path       = require('path');
const rateLimit  = require('express-rate-limit');

// ── Route Imports ─────────────────────────────────────────────
const authRoutes    = require('./routes/auth.routes');
const productRoutes = require('./routes/product.routes');
const tryonRoutes   = require('./routes/tryon.routes');
const orderRoutes   = require('./routes/order.routes');
const userRoutes    = require('./routes/user.routes');

// ── App Initialization ────────────────────────────────────────
const app  = express();
const PORT = process.env.PORT || 5000;

// ─────────────────────────────────────────────────────────────
//  MIDDLEWARE STACK
// ─────────────────────────────────────────────────────────────

// Security headers
app.use(helmet());

// CORS — allow Flutter app to connect
app.use(cors({
  origin: process.env.ALLOWED_ORIGINS?.split(',') || '*',
  methods: ['GET', 'POST', 'PUT', 'PATCH', 'DELETE', 'OPTIONS'],
  allowedHeaders: ['Content-Type', 'Authorization'],
}));

// Request logging (dev format)
app.use(morgan(process.env.NODE_ENV === 'production' ? 'combined' : 'dev'));

// Body parsing
app.use(express.json({ limit: '10mb' }));
app.use(express.urlencoded({ extended: true, limit: '10mb' }));

// Serve uploaded files statically
app.use('/uploads', express.static(path.join(__dirname, 'uploads')));

// Rate limiting — prevent API abuse
const limiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutes
  max: 100,
  standardHeaders: true,
  legacyHeaders: false,
  message: { success: false, message: 'Too many requests, please try again later.' },
});
app.use('/api', limiter);

// ─────────────────────────────────────────────────────────────
//  ROUTES
// ─────────────────────────────────────────────────────────────
app.use('/api/auth',     authRoutes);
app.use('/api/products', productRoutes);
app.use('/api/tryon',    tryonRoutes);
app.use('/api/orders',   orderRoutes);
app.use('/api/users',    userRoutes);

// Health check endpoint
app.get('/health', (req, res) => {
  res.json({
    success: true,
    status: 'running',
    environment: process.env.NODE_ENV || 'development',
    timestamp: new Date().toISOString(),
  });
});

// 404 handler
app.use((req, res) => {
  res.status(404).json({ success: false, message: `Route ${req.path} not found.` });
});

// Global error handler
app.use((err, req, res, next) => {
  console.error('❌ Unhandled Error:', err);
  res.status(err.statusCode || 500).json({
    success: false,
    message: err.message || 'Internal Server Error',
    ...(process.env.NODE_ENV !== 'production' && { stack: err.stack }),
  });
});

// ─────────────────────────────────────────────────────────────
//  MONGODB CONNECTION
// ─────────────────────────────────────────────────────────────
const connectDB = async () => {
  try {
    const conn = await mongoose.connect(process.env.MONGO_URI, {
      useNewUrlParser:    true,
      useUnifiedTopology: true,
    });
    console.log(`✅ MongoDB Connected: ${conn.connection.host}`);
  } catch (err) {
    console.error('❌ MongoDB Connection Failed:', err.message);
    process.exit(1); // Exit if DB is unavailable
  }
};

// ─────────────────────────────────────────────────────────────
//  START SERVER
// ─────────────────────────────────────────────────────────────
const startServer = async () => {
  await connectDB();
  app.listen(PORT, () => {
    console.log(`🚀 Server running at http://localhost:${PORT}`);
    console.log(`📖 Environment: ${process.env.NODE_ENV || 'development'}`);
    console.log(`🩺 Health check: http://localhost:${PORT}/health`);
  });
};

startServer();

module.exports = app; // For testing
