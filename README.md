## Labs Overview

### LAB1: Database Design and ER Modeling

**Objective**: Develop an Entity-Relationship (ER) model for a specified scenario to establish a robust database structure.

In this lab, the ER model was created using [ERDPlus](https://erdplus.com/), an online tool for ER diagramming. The process involved analyzing the case study to identify entities, relationships, and constraints, followed by designing the ER diagram to represent the database schema visually.

---

### LAB2: SQL Schema Implementation

**Objective**: Translate the ER model from LAB1 into a relational schema and implement it using SQL.

The relational schema was implemented in [PostgreSQL](https://www.postgresql.org/), a powerful open-source relational database system. SQL scripts were written to create tables, define primary and foreign keys, and establish constraints. Sample data was inserted to facilitate testing and validation of the schema.

---

### LAB3: Advanced SQL Queries and Optimization

**Objective**: Formulate complex SQL queries to efficiently retrieve and manipulate data.

Utilizing the [psql](https://www.postgresql.org/docs/current/app-psql.html) command-line interface for PostgreSQL, advanced SQL queries were crafted. This included writing multi-table JOINs, nested subqueries, and employing aggregate functions. Query performance was analyzed using PostgreSQL's `EXPLAIN` command to understand execution plans and optimize as necessary.

---

### LAB4: Full-Stack Application Development with Angular and Express.js . Database Normalization and Indexing

**Objective**: Develop a full-stack web application that integrates a PostgreSQL database with an Express.js backend and an Angular frontend. Apply normalization techniques to optimize the database design and implement indexing strategies to enhance query performance.

In this lab, the following technologies were utilized:

- **Backend**: Implemented using [Express.js](https://expressjs.com/), a minimal and flexible Node.js web application framework. The backend connects to a PostgreSQL database to handle data operations and provides RESTful API endpoints for the frontend.

- **Frontend**: Built with [Angular](https://angular.io/), a platform and framework for building single-page client applications using HTML and TypeScript. The Angular application communicates with the Express.js backend to perform CRUD operations and display data to users.

- **Database**: Managed with [PostgreSQL](https://www.postgresql.org/), an open-source relational database system. The database schema was designed to support the application's data requirements, with tables and relationships defined according to the application's needs.

The lab involved setting up the development environment, designing the database schema, implementing the backend API with Express.js, and creating the Angular frontend to interact with the API. Emphasis was placed on ensuring seamless communication between the frontend and backend, as well as efficient data handling and user-friendly interface design.

The existing database schema was evaluated for redundancy and potential anomalies. Normalization principles were applied to restructure tables up to the **Third Normal Form (3NF)**. Indexes were created on frequently queried columns to improve data retrieval times.
