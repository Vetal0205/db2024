## Labs Overview

### LAB1: Database Design and ER Modeling

**Objective**: Develop an Entity-Relationship (ER) model for a specified scenario to establish a robust database structure.

In this lab, the ER model was created using [ERDPlus](https://erdplus.com/), an online tool for ER diagramming [`DB2024.pdf`](https://github.com/Vetal0205/db2024/blob/main/LAB1/DB2024.pdf). The process involved analyzing the case study to identify entities, relationships, and constraints, followed by designing the ER diagram to represent the database schema visually.
The relational schema was implemented in [PostgreSQL](https://www.postgresql.org/), a powerful open-source relational database system. SQL scripts were written to create tables, define primary and foreign keys, and establish constraints [`DV2024.sql`](https://github.com/Vetal0205/db2024/blob/main/LAB1/DB2024.sql). Sample data was inserted to facilitate testing and validation of the schema [`DB2024_data.sql`](https://github.com/Vetal0205/db2024/blob/main/LAB1/DB2024_data.sql).

---

### LAB2: SQL Schema Implementation

**Objective**: Practice executing various SQL `SELECT` queries.  

The focus of the lab was executing different `SELECT` statements to retrieve, filter, and manipulate data [`requests.sql`](https://github.com/Vetal0205/db2024/blob/main/LAB2/requests.sql). 

---

### LAB3: Stored Procedures, Functions, and REST API Implementation

**Objective**: Develop and integrate stored procedures and functions in PostgreSQL while exposing database functionality through a REST API.

The lab was divided into two main parts. The first part focused on writing SQL procedures and functions to encapsulate reusable logic within the database. These were implemented in [`procedures_and_funcs.sql`](https://github.com/Vetal0205/db2024/blob/main/LAB3/procedures_and_funcs.sql), defining various operations such as data insertion, retrieval, and manipulation.

The second part involved creating a RESTful API using Python with the Flask framework. The backend, implemented in [`views.py`](https://github.com/Vetal0205/db2024/blob/main/LAB3/REST/app/views.py), handled HTTP requests and interacted with the PostgreSQL database via the ORM models defined in [`models.py`](https://github.com/Vetal0205/db2024/blob/main/LAB3/REST/app/models.py). The API endpoints allowed performing CRUD operations, leveraging the stored procedures and functions created in the first part of the lab.

---

### LAB4: Full-Stack Application Development with Express.js and MongoDB

**Objective**: Develop a full-stack application to manage hotel and customer data, utilizing Express.js for the backend and MongoDB for the database.

In this lab, the backend was implemented using [Express.js](https://expressjs.com/), a web application framework for Node.js. The application connects to a MongoDB database to manage hotel and customer information. Key components include:

- **Data Models**: Defined using [Mongoose](https://mongoosejs.com/), an ODM (Object Data Modeling) library for MongoDB and Node.js. The models are structured as follows:
  - `Customer` model: Represents customers with fields for name, email, phone, and an array of bookings. Each booking includes room ID, check-in and check-out dates, and total price. [View model](https://github.com/Vetal0205/db2024/blob/main/LAB4/Express/models/Customer.js)
  - `Hotel` model: Represents hotels with fields for name, location, rating, and an array of rooms. Each room includes type, price, and availability status. [View model](https://github.com/Vetal0205/db2024/blob/main/LAB4/Express/models/Hotel.js)

- **Routes**: Defined to handle HTTP requests for hotels and customers:
  - `customers.js`: Manages routes for creating, reading, updating, and deleting customer data. [View routes](https://github.com/Vetal0205/db2024/blob/main/LAB4/Express/routes/customers.js)
  - `hotels.js`: Manages routes for creating, reading, updating, and deleting hotel data. [View routes](https://github.com/Vetal0205/db2024/blob/main/LAB4/Express/routes/hotels.js)

- **Database Connection**: Established in `db.js` using Mongoose to connect to the MongoDB database. [View connection](https://github.com/Vetal0205/db2024/blob/main/LAB4/Express/db.js)

- **Server Initialization**: The server is set up in `index.js`, where middleware is configured, routes are registered, and the server is started on a specified port. Additionally, Swagger is integrated for API documentation. [View server setup](https://github.com/Vetal0205/db2024/blob/main/LAB4/Express/index.js)

Sample data for customers with bookings and hotels with rooms is provided in JSON format to facilitate testing and development:
- [customers_with_bookings.json](https://github.com/Vetal0205/db2024/blob/main/LAB4/customers_with_bookings.json)
- [hotels_with_rooms.json](https://github.com/Vetal0205/db2024/blob/main/LAB4/hotels_with_rooms.json)
