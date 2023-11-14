require('dotenv').config();
const express = require('express');
const mongoose = require('mongoose');
const splitRoutes = require('./routes/splits');

// Express app
const app = express();

// Middleware
app.use(express.json());
app.use((req, res, next) => {
    next(); 
});

// Routes
app.use('/api/splits', splitRoutes);

// Connect to mongoDB
mongoose.connect(process.env.MONGO_URI)
  .then(() => {
    // Listen for requests
    app.listen(process.env.PORT, () => {
      console.log('listening on port', process.env.PORT);
    });
  })
  .catch((error) => {
    console.log(error);
  });