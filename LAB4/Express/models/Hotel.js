const mongoose = require('mongoose');
const Schema = mongoose.Schema;

const roomSchema = new Schema({
    type: {
        type: String,
        required: true,
        enum: ['Standard', 'Deluxe', 'Suite', 'Economy'],
    },
    price: {
        type: Number,
        required: true,
        min: [0, 'Room price cannot be negative'],
    },
    available: {
        type: Boolean,
        required: true,
    }
});

const hotelSchema = new Schema({
    name: {
        type: String,
        required: true, 
    },
    location: {
        type: String,
        required: true, 
    },
    rating: {
        type: Number,
        min: [0, 'Rating cannot be negative'],
        max: [100, 'Rating cannot exceed 100'],
        required: true,
    },
    rooms: [roomSchema]
});

module.exports = mongoose.model('hotel', hotelSchema);
