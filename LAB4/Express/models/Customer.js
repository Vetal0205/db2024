const mongoose = require('mongoose');
const Schema = mongoose.Schema;

const bookingSchema = new Schema({
  room_id: {
    type: String,
    required: true
  },
  check_in_date: {
    type: Date,
    required: true,
  },
  check_out_date: {
    type: Date,
    required: true,
  },
  total_price: {
    type: Number,
    required: true
  }
});

const customerSchema = new Schema({
  name: {
    type: String,
    required: true,
  },
  email: {
    type: String,
    required: true,
    unique: [true, 'Email must be unique.'],
  },
  phone: {
    type: String,
    required: true,
  },
  bookings: [bookingSchema]
});



module.exports = mongoose.model('customer', customerSchema);
