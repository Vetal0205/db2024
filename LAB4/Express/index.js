const express = require('express');
const bodyParser = require('body-parser');
const swaggerJsdoc = require('swagger-jsdoc');
const swaggerUi = require('swagger-ui-express');
var cors = require('cors');
require('./db');

const app = express();
const port = 5000;

const hotelRoutes = require('./routes/hotels');
const customerRoutes = require('./routes/customers');

const swaggerOptions = {
  definition: {
    openapi: '3.0.0',
    info: {
      title: 'Hotel and Customer API',
      version: '1.0.0',
      description: 'API for managing hotel and customer information',
    },
  },
  apis: ['./routes/*.js'],
};

const swaggerSpec = swaggerJsdoc(swaggerOptions);
app.use(cors());
app.use(bodyParser.json());

app.use('/api/hotels', hotelRoutes);
app.use('/api/customers', customerRoutes);

app.use('/api-docs', swaggerUi.serve, swaggerUi.setup(swaggerSpec));

app.listen(port, () => {
  console.log(`Server running on port ${port}`);
});
