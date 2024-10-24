const express = require('express');
const router = express.Router();
const Movie = require('../models/movie');


router.get('/', async (req, res) => {
  try {
    const movies = await Movie.find();
    res.json(movies);
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
});

router.get('/:movieId/timeSlot/:time', async (req, res) => {
    try {
      
      const movie = await Movie.findById(req.params.movieId);
  
      
      if (!movie) {
        return res.status(404).json({ message: 'Movie not found' });
      }
  
      
      const slot = movie.timeSlots.find(slot => slot.time === req.params.time);
  
      if (!slot) {
        return res.status(404).json({ message: 'Time slot not found' });
      }
  
      const availableSeats = slot.capacity - slot.bookedCount;
      res.json({ time: slot.time, availableSeats });
    } catch (err) {
      res.status(500).json({ message: err.message });
    }
  });
  

router.post('/:movieId/timeSlot/:time/reserve', async (req, res) => {
    const { numSeats } = req.body;
  
    try {
      const movie = await Movie.findById(req.params.movieId);
  
      if (!movie) {
        return res.status(404).json({ message: 'Movie not found' });
      }
  
      const slot = movie.timeSlots.find(slot => slot.time === req.params.time);
  
      if (!slot) {
        return res.status(404).json({ message: 'Time slot not found' });
      }
  
      const availableSeats = slot.capacity - slot.bookedCount;
      if (numSeats > availableSeats) {
        return res.status(400).json({ message: 'Not enough seats available' });
      }
  
      slot.bookedCount += numSeats;
      await movie.save();
  
      res.json({ message: 'Reservation successful', remainingSeats: availableSeats - numSeats });
    } catch (err) {
      res.status(500).json({ message: err.message });
    }
  });
  

module.exports = router;
