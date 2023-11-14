const express = require('express');

// Express app
const app = express();

// Middleware
app.use(express.json());
app.use((req, res, next) => {
    next(); 
});

// Routes
app.use('/api/workouts', workoutRoutes);

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