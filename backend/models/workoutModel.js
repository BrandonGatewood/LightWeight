const mongoose = require('mongoose');

const Schema = mongoose.Schema;

/* Workout Schema Details */
const workoutSchema = new Schema({
    name: {
        type: String,
        required: true
    },
    sets: {
        type: [Number],
        required: true
    },
    reps: {
        type: [Number],
        required: true
    },
    weight: {
        type: [Number],
        required: true
    }
})

module.exports = mongoose.model('Workout', workoutSchema);