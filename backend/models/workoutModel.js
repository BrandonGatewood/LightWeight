const mongoose = require('mongoose');

const Schema = mongoose.Schema;

/* Workout Schema Details */
const workoutSchema = new Schema({
    name: {
        type: String,
        required: true
    },
    sets: {
        type: Array,
        required: true
    },
    reps: {
        type: Array,
        required: true
    },
    weight: {
        type: Array,
        required: true
    }
})

module.exports = mongoose.model('Workout', workoutSchema);