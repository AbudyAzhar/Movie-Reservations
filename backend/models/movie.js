const mongoose = require('mongoose');

const timeSlotSchema = new mongoose.Schema({
  time: String,
  capacity: Number,
  bookedCount: { type: Number, default: 0 },
});

const movieSchema = new mongoose.Schema({
  title: String,
  timeSlots: [timeSlotSchema],
});

const Movie = mongoose.model('Movie', movieSchema);

module.exports = Movie;
