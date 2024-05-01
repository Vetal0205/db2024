const express = require('express');
const Hotel = require('../models/Hotel.js');
const { body, validationResult } = require('express-validator');
const router = express.Router();

const validationHotel = [
    body('name').trim().notEmpty().withMessage('Name is required'),
    body('location').trim().notEmpty().withMessage('Location is required'),
    body('rating').notEmpty().isFloat({ min: 0, max: 100 }).withMessage('Rating must be between 0 and 100'),
    body('rooms.*.type').trim().notEmpty().isIn(['Standard', 'Deluxe', 'Suite', 'Economy']).withMessage('Room type is required. Alloweds room types: Standard, Deluxe, Suite, Economy'),
    body('rooms.*.price').notEmpty().isFloat({ min: 0 }).withMessage('Room price must be greater than 0'),
    body('rooms.*.available').notEmpty().isBoolean().withMessage('Room availability must be true or false')
]

/**
 * @swagger
 * components:
 *   schemas:
 *     Room:
 *       type: object
 *       properties:
 *         type:
 *           type: string
 *           enum: ['Standard', 'Deluxe', 'Suite', 'Economy']
 *           description: Type of the room.
 *         price:
 *           type: number
 *           description: Price per night for the room.
 *         available:
 *           type: boolean
 *           description: Availability of the room.
 *       required:
 *         - type
 *         - price
 *         - available
 *     Hotel:
 *       type: object
 *       properties:
 *         name:
 *           type: string
 *           description: Name of the hotel.
 *         location:
 *           type: string
 *           description: Location of the hotel.
 *         rating:
 *           type: number
 *           description: Rating of the hotel out of 100.
 *         rooms:
 *           type: array
 *           items:
 *             $ref: '#/components/schemas/Room'
 *       required:
 *         - name
 *         - location
 *         - rating
 *         - rooms
 */


/**
 * @swagger
 * /hotels:
 *   get:
 *     summary: Retrieve a list of all hotels
 *     description: Returns a list of all hotels with optional filtering by name, location, and rating range.
 *     parameters:
 *       - in: query
 *         name: name
 *         schema:
 *           type: string
 *         description: The name of the hotel to search for.
 *       - in: query
 *         name: location
 *         schema:
 *           type: string
 *         description: The location to search for.
 *       - in: query
 *         name: g_rating
 *         schema:
 *           type: number
 *         description: Minimum hotel rating.
 *       - in: query
 *         name: l_rating
 *         schema:
 *           type: number
 *         description: Maximum hotel rating.
 *     responses:
 *       200:
 *         description: A list of hotels.
 *         content:
 *           application/json:
 *             schema:
 *               type: array
 *               items:
 *                 $ref: '#/components/schemas/Hotel'
 *       500:
 *         description: Server error.
 */
router.get('/', async (req, res) => {
    try {
        const { name, location, g_rating, l_rating } = req.query;
        let filter = {};

        hotels = [];

        if (name) filter.name = new RegExp(name, 'i');
        if (location) filter.location = new RegExp(location, 'i');
        if (g_rating) filter.rating = { $gte: parseFloat(g_rating) };
        if (l_rating) filter.rating = { $lte: parseFloat(l_rating) };

        hotels = await Hotel.find(filter);
        res.status(200).send(hotels);
    } catch (error) {
        res.status(500).send(error);
    }
});
/**
 * @swagger
 * /hotels/rooms:
 *   get:
 *     summary: Get rooms with filtering options
 *     description: Retrieves rooms based on filtering options like type, price range, and availability.
 *     parameters:
 *       - in: query
 *         name: type
 *         schema:
 *           type: string
 *         description: Filter by room type.
 *       - in: query
 *         name: l_price
 *         schema:
 *           type: number
 *         description: Maximum room price to filter by.
 *       - in: query
 *         name: g_price
 *         schema:
 *           type: number
 *         description: Minimum room price to filter by.
 *       - in: query
 *         name: available
 *         schema:
 *           type: boolean
 *         description: Availability of the room (true or false).
 *     responses:
 *       200:
 *         description: Filtered list of rooms.
 *         content:
 *           application/json:
 *             schema:
 *               type: array
 *               items:
 *                 $ref: '#/components/schemas/Room'
 *       500:
 *         description: Server error.
 */

router.get('/rooms', async (req, res) => {
    hotels = [];
    try {
        const { type, l_price, g_price, available } = req.query;
        let filter = {};

        let roomFilter = {};
        if (type) roomFilter.type = new RegExp(type, 'i');  
        if (g_price) roomFilter.price = { $gte: parseFloat(g_price) };  
        if (l_price) roomFilter.price = { ...roomFilter.price, $lte: parseFloat(l_price) };  
        if (available !== undefined) roomFilter.available = available === 'true';  

        if (Object.keys(roomFilter).length > 0) {
            filter.rooms = { $elemMatch: roomFilter };
        }

        hotels = await Hotel.find(filter);
        res.status(200).send(hotels.map(hotel => hotel.rooms));
    } catch (error) {
        console.error(error);
        res.status(500).send({ message: "Error retrieving rooms", error });
    }
});

/**
 * @swagger
 * /hotels:
 *   post:
 *     summary: Create a new hotel
 *     description: Adds a new hotel to the database.
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             $ref: '#/components/schemas/Hotel'
 *     responses:
 *       201:
 *         description: Hotel created successfully.
 *       400:
 *         description: Invalid input, object invalid.
 *       500:
 *         description: Server error.
 */
router.post('/', validationHotel, async (req, res) => {
    const errors = validationResult(req);

    hotels = [];

    if (!errors.isEmpty()) {
        return res.status(400).json({ errors: errors.array() });
    }
    // if rooms document is empty
    if (!req.body.rooms) {
        req.body.rooms = [];
    }
    try {
        hotel = new Hotel(req.body);
        await hotel.save();
        res.status(201).send(hotel);
    } catch (error) {
        res.status(500).send(error);
    }
});
/**
 * @swagger
 * /hotels/unavailable-rooms:
 *   get:
 *     summary: Get all unavailable rooms
 *     description: Retrieves all rooms across all hotels that are currently unavailable.
 *     responses:
 *       200:
 *         description: A list of unavailable rooms.
 *         content:
 *           application/json:
 *             schema:
 *               type: array
 *               items:
 *                 $ref: '#/components/schemas/Room'
 *       500:
 *         description: Server error.
 */


router.get('/unavailable-rooms', async (req, res) => {
    result = [];
    try {
        results = await Hotel.aggregate([
            { $unwind: '$rooms' },
            { $match: { 'rooms.available': false } }
        ],
            {
                maxTimeMS: 60000,
                allowDiskUse: true
            });

        res.status(200).send(results);
    } catch (error) {
        res.status(500).send(error);
    }
});
/**
 * @swagger
 * /hotels/available-rooms:
 *   get:
 *     summary: Get all available rooms
 *     description: Retrieves all rooms across all hotels that are currently available.
 *     responses:
 *       200:
 *         description: A list of available rooms.
 *         content:
 *           application/json:
 *             schema:
 *               type: array
 *               items:
 *                 $ref: '#/components/schemas/Room'
 *       500:
 *         description: Server error.
 */


router.get('/available-rooms', async (req, res) => {
    result = [];
    try {
        results = await Hotel.aggregate([
            { $unwind: '$rooms' },
            {
                $group: {
                    _id: '$name',
                    availableRooms: { $sum: 1 }
                }
            }
        ],
            { maxTimeMS: 60000, allowDiskUse: true });

        res.status(200).send(results);
    } catch (error) {
        res.status(500).send(error);
    }
});
/**
 * @swagger
 * /hotels/all-room-types:
 *   get:
 *     summary: Get all room types
 *     description: Retrieves a list of all room types and the number of each type available across all hotels.
 *     responses:
 *       200:
 *         description: A list of room types with their counts.
 *         content:
 *           application/json:
 *             schema:
 *               type: array
 *               items:
 *                 properties:
 *                   type:
 *                     type: string
 *                   count:
 *                     type: integer
 *       500:
 *         description: Server error.
 */

router.get('/all-room-types', async (req, res) => {
    result = [];
    try {
        results = await Hotel.aggregate([
            { $unwind: '$rooms' },
            {
                $group: {
                    _id: '$rooms.type',
                    count: { $sum: 1 }
                }
            }
        ],
            { maxTimeMS: 60000, allowDiskUse: true });

        res.status(200).send(results);
    } catch (error) {
        res.status(500).send(error);
    }
});
/**
 * @swagger
 * /hotels/highest-room-price:
 *   get:
 *     summary: Get the highest room price
 *     description: Finds the highest price of rooms across all hotels.
 *     responses:
 *       200:
 *         description: Highest room price found.
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 mostExpensiveRoom:
 *                   type: number
 *       500:
 *         description: Server error.
 */


router.get('/highest-room-price', async (req, res) => {
    result = [];
    try {
        results = await Hotel.aggregate([
            { $unwind: '$rooms' },
            {
                $group: {
                    _id: '$name',
                    mostExpensiveRoom: {
                        $max: '$rooms.price'
                    }
                }
            }
        ],
            { maxTimeMS: 60000, allowDiskUse: true });

        res.status(200).send(results);
    } catch (error) {
        res.status(500).send(error);
    }
});
/**
 * @swagger
 * /hotels/lowest-room-price:
 *   get:
 *     summary: Get the lowest room price
 *     description: Finds the lowest price of rooms across all hotels.
 *     responses:
 *       200:
 *         description: Lowest room price found.
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 mostExpensiveRoom:
 *                   type: number
 *       500:
 *         description: Server error.
 */


router.get('/lowest-room-price', async (req, res) => {
    result = [];
    try {
        results = await Hotel.aggregate([
            { $unwind: '$rooms' },
            {
                $group: {
                    _id: '$name',
                    mostExpensiveRoom: {
                        $min: '$rooms.price'
                    }
                }
            }
        ],
            { maxTimeMS: 60000, allowDiskUse: true });

        res.status(200).send(results);
    } catch (error) {
        res.status(500).send(error);
    }
});
/**
 * @swagger
 * /hotels/avarage-hotel-rating:
 *   get:
 *     summary: Get average hotel rating
 *     description: Calculates the average rating of all hotels.
 *     responses:
 *       200:
 *         description: Average rating of hotels.
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 averageRating:
 *                   type: number
 *       500:
 *         description: Server error.
 */


router.get('/avarage-hotel-rating', async (req, res) => {
    result = [];
    try {
        results = await Hotel.aggregate([
            {
                $group: {
                    _id: null,
                    averageRating: { $avg: '$rating' }
                }
            }
        ],
            { maxTimeMS: 60000, allowDiskUse: true });

        res.status(200).send(results);
    } catch (error) {
        res.status(500).send(error);
    }
});
/**
 * @swagger
 * /hotels/avarage-room-price-per-type:
 *   get:
 *     summary: Get average room price per type
 *     description: Retrieves the average price of rooms grouped by type across all hotels.
 *     responses:
 *       200:
 *         description: A list of average prices per room type.
 *         content:
 *           application/json:
 *             schema:
 *               type: array
 *               items:
 *                 properties:
 *                   type:
 *                     type: string
 *                   averagePrice:
 *                     type: number
 *       500:
 *         description: Server error.
 */


router.get('/avarage-room-price-per-type', async (req, res) => {
    result = [];
    try {
        results = await Hotel.aggregate([
            { $unwind: '$rooms' },
            {
                $group: {
                    _id: '$rooms.type',
                    averagePrice: { $avg: '$rooms.price' }
                }
            },
            { $sort: { averagePrice: 1 } }
        ],
            { maxTimeMS: 60000, allowDiskUse: true });

        res.status(200).send(results);
    } catch (error) {
        res.status(500).send(error);
    }
});
/**
 * @swagger
 * /hotels/{id}:
 *   get:
 *     summary: Get a hotel by ID
 *     description: Retrieves detailed information about a specific hotel by its ID.
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: string
 *         description: Unique identifier of the hotel to retrieve.
 *     responses:
 *       200:
 *         description: Detailed hotel information.
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/Hotel'
 *       404:
 *         description: Hotel not found.
 *       500:
 *         description: Server error.
 */
router.get('/:id', async (req, res) => {
    hotel = [];
    try {
        hotel = await Hotel.findById(req.params.id);
        if (hotel.length == 0) {
            return res.status(404).send();
        }
        res.send(hotel);
    } catch (error) {
        res.status(500).send(error);
    }
});
/**
 * @swagger
 * /hotels/{id}:
 *   put:
 *     summary: Update a hotel by ID
 *     description: Updates the details of an existing hotel. All hotel fields must be provided.
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: string
 *         description: Unique identifier of the hotel to update.
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             $ref: '#/components/schemas/Hotel'
 *     responses:
 *       200:
 *         description: Hotel updated successfully.
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/Hotel'
 *       400:
 *         description: Invalid input, object invalid.
 *       404:
 *         description: Hotel not found.
 *       500:
 *         description: Server error.
 */


router.put('/:id', validationHotel, async (req, res) => {
    hotel = [];
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
        return res.status(400).json({ errors: errors.array() });
    }
    try {
        hotel = await Hotel.findByIdAndUpdate(req.params.id, req.body, { new: true, runValidators: true });
        if (!hotel) {
            return res.status(404).send();
        }
        res.send(hotel);
    } catch (error) {
        res.status(500).send(error);
    }
});
/**
 * @swagger
 * /hotels/{id}:
 *   delete:
 *     summary: Delete a hotel by ID
 *     description: Permanently deletes a hotel from the database.
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: string
 *         description: Unique identifier of the hotel to delete.
 *     responses:
 *       200:
 *         description: Hotel deleted successfully.
 *       404:
 *         description: Hotel not found.
 *       500:
 *         description: Server error.
 */


router.delete('/:id', async (req, res) => {
    hotel = [];
    try {
        hotel = await Hotel.findByIdAndDelete(req.params.id);
        if (!hotel) {
            return res.status(404).send();
        }
        res.send(hotel);
    } catch (error) {
        res.status(500).send(error);
    }
});


module.exports = router;