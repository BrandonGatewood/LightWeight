const express = require('express');
const {
    getWorkouts,
    getWorkout,
    postWorkout,
    deleteWorkout,
    patchWorkout
} = require('../controllers/workoutController');
const router = express.Router();

// Get all workouts
router.get('/', getWorkouts);

// Get a single workout 
router.get('/:id', getWorkout);

// Post a new workout
router.post('/', postWorkout);

// Delete a workout
router.delete('/:id', deleteWorkout);

// Patch a workout
router.patch('/:id', patchWorkout);

module.exports = router;