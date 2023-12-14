const mongoose = require('mongoose');
const Schema = mongoose.Schema;

/* Split Schema Details */
// name is the split name that a user can come up with 
// numOnDays is the number of days users will be working out for the week
// numOffDays is the number of days users will be resting for the week
// workouts is an array of workout documents
const splitSchema = new Schema({
    name: {
        type: String,
        require: true
    },
    numOnDays: {
        type: Number,
        require: true
    },
    numOffDays: {
        type: Number,
        require: true
    },
    workouts: {
        type: [[{
            WorkoutName: {
                type: String,
                require: true
            },
            sets: {
                type: [Number],
                require: true
            },
            reps: {
                type: [Number],
                require: true
            },
            weight: {
                type: [Number],
                require: true
            },
        }]],
        require: true
    }
});

module.exports = mongoose.model('Split', splitSchema);