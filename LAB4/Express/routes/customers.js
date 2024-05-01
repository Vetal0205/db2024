const express = require('express');
const Customer = require('../models/Customer.js');
const { body, validationResult } = require('express-validator');
const router = express.Router();

const validationCustomer = [
    body('name').trim().notEmpty().withMessage('Customer name is required.'),
    body('email').trim().notEmpty().isEmail().withMessage('Please provide a valid email address.'),
    body('phone').trim().notEmpty().matches(/\d{3}-\d{3}-\d{4}/).withMessage('Phone number is required. Phone number format must match patern: XXX-XXX-XXXX.'),
    body('bookings').optional({ checkFalsy: true, nullable: true }).isArray().withMessage('Bookings should be an array if provided.'),
    body('bookings.*.room_id').if(body('bookings').exists({ checkFalsy: true })).notEmpty().withMessage('Room ID must be specified.'),
    body('bookings.*.check_in_date').if(body('bookings').exists({ checkFalsy: true })).isISO8601().withMessage('Check-in date must be a valid date (YYYY-MM-DD).'),
    body('bookings.*.check_out_date').if(body('bookings').exists({ checkFalsy: true })).isISO8601().withMessage('Check-out date must be a valid date (YYYY-MM-DD).'),
    body('bookings.*.total_price').if(body('bookings').exists({ checkFalsy: true })).isFloat({ min: 0 }).withMessage('Total price must be a positive number.')
]
/**
 * @swagger
 * components:
 *   schemas:
 *     Booking:
 *       type: object
 *       properties:
 *         room_id:
 *           type: string
 *           description: ID of the booked room.
 *         check_in_date:
 *           type: string
 *           format: date
 *           description: Check-in date.
 *         check_out_date:
 *           type: string
 *           format: date
 *           description: Check-out date.
 *         total_price:
 *           type: number
 *           description: Total price for the stay.
 *       required:
 *         - room_id
 *         - check_in_date
 *         - check_out_date
 *         - total_price
 *     Customer:
 *       type: object
 *       properties:
 *         name:
 *           type: string
 *           description: Customer's name.
 *         email:
 *           type: string
 *           format: email
 *           description: Customer's email address.
 *         phone:
 *           type: string
 *           description: Customer's phone number.
 *         bookings:
 *           type: array
 *           items:
 *             $ref: '#/components/schemas/Booking'
 *       required:
 *         - name
 *         - email
 *         - phone
 */

/**
 * @swagger
 * /customers:
 *   get:
 *     summary: Retrieve a list of customers
 *     description: Retrieve a list of customers filtered by name, email, phone, or bookings.
 *     parameters:
 *       - in: query
 *         name: name
 *         schema:
 *           type: string
 *         description: Customer name to filter by.
 *       - in: query
 *         name: email
 *         schema:
 *           type: string
 *         description: Customer email to filter by.
 *       - in: query
 *         name: phone
 *         schema:
 *           type: string
 *         description: Customer phone to filter by.
 *       - in: query
 *         name: bookings
 *         schema:
 *           type: string
 *         description: Bookings to filter by.
 *     responses:
 *       200:
 *         description: An array of customers.
 *         content:
 *           application/json:
 *             schema:
 *               type: array
 *               items:
 *                 $ref: '#/components/schemas/Customer'
 *       500:
 *         description: Error occurred.
 */


router.get('/', async (req, res) => {
    try {
        const { name, email, phone, bookings } = req.query;
        let filter = {};

        customers = []

        if (name) filter.name = new RegExp(name, 'i');
        if (email) filter.email = new RegExp(email, 'i');
        if (phone) filter.phone = new RegExp(phone, 'i');
        if (bookings) filter.bookings = new RegExp(bookings, 'i');

        customers = await Customer.find(filter);
        res.status(200).send(customers);
    } catch (error) {
        res.status(500).send(error);
    }
});
/**
 * @swagger
 * /customers/bookings:
 *   get:
 *     summary: Retrieve customer bookings
 *     description: Retrieve bookings of customers filtered by room ID, check-in, and check-out dates.
 *     parameters:
 *       - in: query
 *         name: room_id
 *         schema:
 *           type: string
 *         description: Room ID to filter bookings.
 *       - in: query
 *         name: check_in_date
 *         schema:
 *           type: string
 *           format: date
 *         description: Check-in date to filter bookings.
 *       - in: query
 *         name: check_out_date
 *         schema:
 *           type: string
 *           format: date
 *         description: Check-out date to filter bookings.
 *     responses:
 *       200:
 *         description: A list of bookings.
 *         content:
 *           application/json:
 *             schema:
 *               type: array
 *               items:
 *                 $ref: '#/components/schemas/Booking'
 *       500:
 *         description: Error retrieving bookings.
 */
router.get('/bookings', async (req, res) => {
    customers = [];
    try {
        const { room_id, check_in_date, check_out_date } = req.query;
        let query = {};

        let bookingFilters = {};
        if (room_id) bookingFilters.room_id = new RegExp(room_id, 'i'); 
        if (check_in_date) bookingFilters.check_in_date = new Date(check_in_date); 
        if (check_out_date) bookingFilters.check_out_date = new Date(check_out_date);

       
        if (Object.keys(bookingFilters).length > 0) {
            query.bookings = { $elemMatch: bookingFilters };
        }

        customers = await Customer.find(query);
        res.status(200).send(customers.map(customer => customer.bookings));
    } catch (error) {
        console.error(error);
        res.status(500).send({ message: "Error retrieving customers by bookings", error });
    }
});
/**
 * @swagger
 * /customers:
 *   post:
 *     summary: Create a new customer
 *     description: Create a new customer with name, email, phone, and bookings.
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             $ref: '#/components/schemas/Customer'
 *     responses:
 *       201:
 *         description: Customer created successfully.
 *       400:
 *         description: Invalid data provided.
 *       500:
 *         description: Error creating customer.
 */


router.post('/', validationCustomer, async (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
        return res.status(400).json({ errors: errors.array() });
    }
    // if bookings document is empty
    if (!req.body.bookings) {
        req.body.bookings = [];
    }
    try {
        const customer = new Customer(req.body);
        await customer.save();
        res.status(201).send(customer);
    } catch (error) {
        res.status(500).send(error);
    }
});
/**
 * @swagger
 * /customers/{id}:
 *   get:
 *     summary: Retrieve a single customer by ID
 *     description: Retrieve detailed information of a customer by their unique ID.
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: string
 *         description: Unique identifier of the customer.
 *     responses:
 *       200:
 *         description: Customer retrieved successfully.
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/Customer'
 *       404:
 *         description: Customer not found.
 *       500:
 *         description: Error retrieving customer.
 */


router.get('/:id', async (req, res) => {
    customer = [];
    try {
        customer = await Customer.findById(req.params.id);
        if (customer.length == 0) {
            return res.status(404).send();
        }
        res.send(customer);
    } catch (error) {
        res.status(500).send(error);
    }
});
/**
 * @swagger
 * /customers/{id}:
 *   put:
 *     summary: Update a customer by ID
 *     description: Updates an existing customer's details based on the provided ID.
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: string
 *         description: Unique identifier of the customer to update.
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             $ref: '#/components/schemas/Customer'
 *     responses:
 *       200:
 *         description: Customer updated successfully.
 *       400:
 *         description: Validation error for input data.
 *       404:
 *         description: Customer not found.
 *       500:
 *         description: Server error.
 */
router.put('/:id', validationCustomer, async (req, res) => {
    customer = [];
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
        return res.status(400).json({ errors: errors.array() });
    }
    try {
        customer = await Customer.findByIdAndUpdate(req.params.id, req.body, { new: true, runValidators: true });
        if (!customer) {
            return res.status(404).send();
        }
        res.send(customer);
    } catch (error) {
        res.status(500).send(error);
    }
});
/**
 * @swagger
 * /customers/{id}:
 *   delete:
 *     summary: Delete a customer by ID
 *     description: Deletes a customer from the database by their ID.
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: string
 *         description: Unique identifier of the customer to delete.
 *     responses:
 *       200:
 *         description: Customer deleted successfully.
 *       404:
 *         description: Customer not found.
 *       500:
 *         description: Server error.
 */

router.delete('/:id', async (req, res) => {
    customer = [];
    try {
        customer = await Customer.findByIdAndDelete(req.params.id);
        if (customer.length == 0) {
            return res.status(404).send();
        }
        res.send(customer);
    } catch (error) {
        res.status(500).send(error);
    }
});
module.exports = router;