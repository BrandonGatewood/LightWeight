const express = require('express');
const {
    getSplits,
    getSplit,
    postSplit,
    deleteSplit,
    patchSplit
} = require('../controllers/splitController');

const router = express.Router();

// Get all workouts in the workout split
router.get('/', getSplits);

// Get a single workout in the workout split
router.get('/:id', getSplit);

// Post a new workout to the workout split
router.post('/', postSplit);

// Delete a workout from the workout split
router.delete('/:id', deleteSplit);

// Patch a workout from the workout split
router.patch('/:id', patchSplit);

module.exports = router;