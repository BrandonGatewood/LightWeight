const Split = require('../models/splitModel');
const mongoose = require('mongoose');

// GET all workouts from the workout split
const getSplits = async (req, res) => {
    const split = await Split.find({});

    res.status(200).json(split);
}

// GET a single split
const getSplit = async (req, res) => {

}

// POST a new split 
const postSplit = async (req, res) => {

}

// DELETE a single split 
const deleteSplit = async (req, res) => {

}

// PATCH a split 
const patchSplit = async (req, res) => {

}

// Export splitController object
module.exports = {
    getSplits,
    getSplit,
    postSplit,
    deleteSplit,
    patchSplit
};