const Split = require('../models/splitModel');
const mongoose = require('mongoose');

// GET all workouts from the workout split
const getSplits = async (req, res) => {
    const split = await Split.find({});

    res.status(200).json(split);
}

// GET a single split
const getSplit = async (req, res) => {
    const { id } = req.params;

    if(!mongoose.Types.ObjectId.isValid(id))
        return res.status(400).json({ error : 'Invalid id' });

    const split = await Split.findById(id);

    if(!split)
        return res.status(404).json({ error : 'No Such Split found.' });

    res.status(200).json(split);
}

// POST a new split 
const postSplit = async (req, res) => {
    const { name, numOnDays, numOffDays, workouts } = req.body;

    // Add document to database
    try {
        const split = await Split.create({ name, numOnDays, numOffDays, workouts });
        res.status(200).json(split);
    }
    catch(error) {
        res.status(400).json({ error : error.message });
    }
}

// DELETE a single split 
const deleteSplit = async (req, res) => {
    const { id } = req.params;

    if(!mongoose.Types.ObjectId.isValid(id))
        return res.status(400).json({ error : 'Invalid id' });

    const split = await Split.findOneAndDelete(id);

    if(!split)
        return res.status(404).json({ error : 'No Such Split found.' });

    res.status(200).json(split);
}

// PATCH a split 
const patchSplit = async (req, res) => {
    const { id } = req.params;

    if(!mongoose.Types.ObjectId.isValid(id))
        return res.status(400).json({ error : 'Invalid id' });

    const split = await Split.findOneAndUpdate({ _id : id }, {
        ...req.body
    });

    if(!split)
        return res.status(404).json({ error : 'No Such Split found.' });

    res.status(200).json(split);

}

// Export splitController object
module.exports = {
    getSplits,
    getSplit,
    postSplit,
    deleteSplit,
    patchSplit
};