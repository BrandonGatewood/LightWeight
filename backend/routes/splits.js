const express = require('express');
const {
    getSplits,
    getSplit,
    postSplit,
    deleteSplit,
    patchSplit
} = require('../controllers/splitController');

const router = express.Router();

// Get all workouts
router.get('/', getSplits);

// Get a single workout 
router.get('/:id', getSplit);

// Post a new workout
router.post('/', postSplit);

// Delete a workout
router.delete('/:id', deleteSplit);

// Patch a workout
router.patch('/:id', patchSplit);

module.exports = router;