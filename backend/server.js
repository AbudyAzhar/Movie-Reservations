const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');

const app = express();
app.use(express.json());
app.use(cors());

const movieRoutes = require('./routes/movies');
app.use('/api/movies', movieRoutes);
const PORT = process.env.PORT || 5001;


mongoose.connect('mongodb://localhost:27017/movies', {})
  .then(() => console.log('MongoDB connected'))
  .catch(err => console.log(err));


app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});
