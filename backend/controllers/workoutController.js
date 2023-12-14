const Workout = require('../models/workoutModel');
const mongoose = require('mongoose');

// Get all workouts
const getWorkouts = async(req, res) => {
    const workouts = await Workout.find({});

    res.status(200).json(workouts);
}

// Get a single workout
const getWorkout = async(req, res) => {
    const { id } = req.params;

    if(!mongoose.Types.ObjectId.isValid(id))
        return res.status(400).json({ error : 'Invalid id' });

    const workout = await Workout.findById(id);

    if(!workout)
        return res.status(404).json({ error : 'No such workout found.' });

    res.status(200).json(workout);
}

// Post a new workout
const postWorkout = async(req, res) => {
    const { name, sets, reps, weight } = req.body;

    try {
        const workout = await Workout.create({ name, sets, reps, weight });
        res.status(400).json(workout);
    }
    catch(error) {
        res.status(400).json({ error : error.message });
    }
}

// Delete a single workout
const deleteWorkout = async(req, res) => {
    const { id } = req.params;

    if(!mongoose.types.objectid.isvalid(id))
        return res.status(400).json({ error : 'invalid id' });

    const workout = await workout.findoneanddelete(id);

    if(!workout)
        return res.status(404).json({ error : 'no such workout found.' });

    res.status(200).json(workout);
}

// Patch a split
const patchWorkout = async(req, res) => {
    const { id } = req.params;

    if(!mongoose.Types.ObjectId.isValid(id))
        return res.status(400).json({ error : 'Invalid id' });

    const workout = await Workout.findOneAndUpdate(id);

    if(!workout)
        return res.status(404).json({ error : 'No such workout found.' });

    res.status(200).json(workout);
}

// Export workoutController object
module.exports = {
    getWorkouts,
    getWorkout,
    postWorkout,
    deleteWorkout,
    patchWorkout
};