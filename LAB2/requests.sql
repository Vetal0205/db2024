SELECT * FROM hotels LIMIT 50;
SELECT * FROM customers LIMIT 50;
SELECT * FROM bookings LIMIT 50;
SELECT * FROM rooms LIMIT 50;
SELECT * FROM rooms WHERE hotel_id = 1; 
SELECT * FROM hotels WHERE rating > 4.5;
SELECT * FROM rooms WHERE type = 'Economy' AND available = true;
SELECT * FROM bookings WHERE customer_id = 226;
SELECT bookings.*, customers.name, customers.phone FROM bookings JOIN customers ON bookings.customer_id = customers.id; -- показує бронювання на клієнта
SELECT rooms.*, hotels.name, hotels.location FROM rooms JOIN hotels ON rooms.hotel_id = hotels.id; -- об'єднання кімнат та готелей
SELECT customer_id, SUM(total_price) AS total_spent FROM bookings GROUP BY customer_id; -- показує повно ціну для кожного користувача, GROUP BY поєднує користувачів за id
SELECT * FROM rooms WHERE price BETWEEN 1000 AND 5000;
SELECT * FROM bookings WHERE check_in_date = '2023-01-01';
SELECT * FROM customers WHERE email LIKE '%@dell.com';
SELECT * FROM rooms WHERE type = 'Deluxe';
SELECT bookings.*, rooms.type, rooms.price, hotels.name, hotels.location FROM bookings JOIN rooms ON bookings.room_id = rooms.id JOIN hotels ON rooms.hotel_id = hotels.id; -- поєднує поля 3х таблиць
SELECT hotels.name, COUNT(rooms.id) AS room_count FROM hotels JOIN rooms ON hotels.id = rooms.hotel_id GROUP BY hotels.id; -- кількість кімнат у готелях
SELECT name, location FROM hotels WHERE location LIKE '%Solna%';
SELECT DISTINCT type FROM rooms; -- перелік можливих типів
SELECT customers.name, bookings.check_in_date, bookings.check_out_date FROM customers JOIN bookings ON customers.id = bookings.customer_id WHERE bookings.check_in_date >= '2023-01-01';
SELECT MAX(rating) AS highest_rating FROM hotels;
SELECT rooms.type, AVG(rooms.price) AS avg_price FROM rooms GROUP BY rooms.type ORDER BY avg_price;
SELECT * FROM rooms WHERE available = false ORDER BY price DESC;
SELECT customers.name, customers.email FROM customers WHERE NOT EXISTS (SELECT * FROM bookings WHERE customers.id = bookings.customer_id) LIMIT 10; -- вибірка клієнтів без бронювань
SELECT bookings.id, customers.name AS customer_name, rooms.type AS room_type, bookings.total_price FROM bookings JOIN customers ON bookings.customer_id = customers.id JOIN rooms ON bookings.room_id = rooms.id WHERE bookings.total_price > 10000;
SELECT COUNT(*) AS total_bookings, check_in_date FROM bookings GROUP BY check_in_date ORDER BY total_bookings DESC;
SELECT hotels.name AS hotel_name, AVG(rooms.price) AS average_room_price FROM hotels JOIN rooms ON hotels.id = rooms.hotel_id GROUP BY hotels.name HAVING AVG(rooms.price) > 20000;
SELECT type, COUNT(*) AS number_of_rooms, AVG(price) AS average_price FROM rooms WHERE available = true GROUP BY type;
SELECT customer_id, COUNT(*) AS number_of_bookings FROM bookings GROUP BY customer_id ORDER BY customer_id ASC;
SELECT rooms.id, rooms.type, hotels.name AS hotel_name FROM rooms JOIN hotels ON rooms.hotel_id = hotels.id WHERE rooms.type LIKE '%Economy%' AND rooms.available = true;
SELECT customers.name, SUM(bookings.total_price) AS total_spending FROM customers JOIN bookings ON customers.id = bookings.customer_id GROUP BY customers.id ORDER BY total_spending DESC LIMIT 10; -- клієнт та його витрати на кімнату (будуть повтори клієнтів)
SELECT hotels.name, COUNT(bookings.id) AS number_of_bookings FROM hotels JOIN rooms ON hotels.id = rooms.hotel_id JOIN bookings ON rooms.id = bookings.room_id GROUP BY hotels.id ORDER BY number_of_bookings DESC;
SELECT rooms.type, MIN(rooms.price) AS min_price FROM rooms GROUP BY rooms.type;
SELECT name, email, phone FROM customers WHERE email LIKE '%.com' AND phone LIKE '700-%';
SELECT rooms.type, COUNT(*) AS count FROM rooms WHERE available = true AND price < 20000 GROUP BY rooms.type ORDER BY count DESC;
SELECT bookings.id, customers.name, rooms.type, (bookings.check_out_date - bookings.check_in_date) * rooms.price AS estimated_cost FROM bookings JOIN customers ON bookings.customer_id = customers.id JOIN rooms ON bookings.room_id = rooms.id;
SELECT hotels.location, AVG(hotels.rating) AS average_rating FROM hotels GROUP BY hotels.location HAVING AVG(hotels.rating) >= 4;
SELECT customers.id, customers.name, COUNT(bookings.id) AS booking_count FROM customers LEFT JOIN bookings ON customers.id = bookings.customer_id GROUP BY customers.id HAVING COUNT(bookings.id) > 0;
SELECT hotels.name, rooms.type, COUNT(rooms.id) AS type_count FROM hotels JOIN rooms ON hotels.id = rooms.hotel_id GROUP BY hotels.name, rooms.type HAVING COUNT(rooms.id) > 3;
SELECT bookings.customer_id, bookings.room_id, bookings.check_in_date, bookings.check_out_date, rooms.price * (bookings.check_out_date - bookings.check_in_date) AS booking_price FROM bookings JOIN rooms ON bookings.room_id = rooms.id WHERE bookings.check_out_date > bookings.check_in_date;
SELECT DISTINCT customers.name FROM bookings JOIN customers ON bookings.customer_id = customers.id JOIN rooms ON bookings.room_id = rooms.id WHERE rooms.type = 'Suite';
SELECT rooms.hotel_id, COUNT(*) AS total_rooms, COUNT(CASE WHEN rooms.available THEN 1 ELSE 0 END) AS available_rooms FROM rooms GROUP BY rooms.hotel_id;
SELECT name FROM customers WHERE id IN (SELECT customer_id FROM bookings WHERE check_in_date BETWEEN '2023-01-01' AND '2023-12-31');
SELECT type, (SELECT COUNT(*) FROM rooms AS r2 WHERE r2.type = rooms.type AND r2.available = false) AS unavailable_rooms_count FROM rooms GROUP BY type;
SELECT hotels.name AS hotel_name, COUNT(DISTINCT bookings.id) AS bookings_count FROM hotels INNER JOIN rooms ON hotels.id = rooms.hotel_id INNER JOIN bookings ON rooms.id = bookings.room_id GROUP BY hotels.id ORDER BY bookings_count DESC;
SELECT type, MAX(price) AS highest_price, MIN(price) AS lowest_price FROM rooms GROUP BY type;
SELECT customers.name, COUNT(bookings.id) AS bookings_made FROM customers LEFT JOIN bookings ON customers.id = bookings.customer_id WHERE customers.name = 'Wally Crut' GROUP BY customers.id ORDER BY bookings_made DESC;
SELECT hotel_id, location, AVG(rating) AS average_hotel_rating FROM rooms JOIN hotels ON rooms.hotel_id = hotels.id GROUP BY hotel_id, location HAVING AVG(rating) > 80.0;
SELECT rooms.hotel_id, rooms.type, COUNT(*) AS total_rooms_of_type FROM rooms WHERE available = false GROUP BY rooms.hotel_id, rooms.type ORDER BY total_rooms_of_type DESC;
SELECT customers.name AS customer_name, bookings.id AS booking_id, rooms.type AS room_type, bookings.check_out_date FROM bookings JOIN customers ON bookings.customer_id = customers.id JOIN rooms ON bookings.room_id = rooms.id WHERE bookings.check_out_date < CURRENT_DATE; -- Від поточної дати
SELECT COUNT(DISTINCT hotel_id) AS number_of_hotels_with_bookings FROM bookings JOIN rooms ON bookings.room_id = rooms.id; -- просто кількість готелей в яких забронювали кімнати
SELECT hotels.name, AVG(bookings.total_price) AS average_booking_price FROM bookings JOIN rooms ON bookings.room_id = rooms.id JOIN hotels ON rooms.hotel_id = hotels.id GROUP BY hotels.id;
SELECT hotels.location, rooms.type, COUNT(bookings.id) AS bookings_count FROM hotels LEFT JOIN rooms ON rooms.hotel_id = hotels.id JOIN bookings ON rooms.id = bookings.room_id GROUP BY hotels.location, rooms.type ORDER BY bookings_count;
SELECT customers.email, COUNT(bookings.id) AS booking_count FROM customers JOIN bookings ON customers.id = bookings.customer_id GROUP BY customers.email HAVING COUNT(bookings.id) > 0;
SELECT DISTINCT customers.name FROM bookings JOIN customers ON bookings.customer_id = customers.id WHERE bookings.total_price > (SELECT AVG(total_price) FROM bookings) ORDER BY customers.name; -- вибирає користувачів у кого ціна за кімнати вище середнього
SELECT hotels.name, COUNT(*) AS room_count FROM hotels JOIN rooms ON hotels.id = rooms.hotel_id WHERE rooms.available = true GROUP BY hotels.name HAVING COUNT(*) > 5;
SELECT room_id, COUNT(*) AS booking_frequency FROM bookings GROUP BY room_id ORDER BY booking_frequency DESC LIMIT 5;
SELECT customers.name, bookings.check_in_date FROM customers JOIN bookings ON customers.id = bookings.customer_id WHERE bookings.check_in_date > '2023-01-05' AND bookings.check_out_date < '2023-08-31';
SELECT rooms.type, COUNT(*) FILTER (WHERE available = true) AS available_rooms, COUNT(*) FILTER (WHERE available = false) AS booked_rooms FROM rooms GROUP BY rooms.type;
SELECT hotel_id, (SELECT name FROM hotels WHERE id = rooms.hotel_id) AS hotel_name, COUNT(*) AS room_count FROM rooms GROUP BY hotel_id;
SELECT bookings.check_in_date, bookings.check_out_date, SUM(bookings.total_price) AS total_income FROM bookings GROUP BY bookings.check_in_date, bookings.check_out_date ORDER BY total_income DESC;
SELECT customers.name, (SELECT COUNT(*) FROM bookings WHERE customer_id = customers.id) AS booking_count FROM customers ORDER BY booking_count DESC LIMIT 10;
SELECT COUNT(DISTINCT customers.id) AS unique_customers FROM customers;
SELECT hotels.name, COUNT(rooms.id) AS rooms_count FROM hotels JOIN rooms ON hotels.id = rooms.hotel_id WHERE rooms.available = true GROUP BY hotels.id ORDER BY rooms_count DESC;
SELECT hotels.location, AVG(bookings.total_price) AS avg_price FROM hotels JOIN rooms ON hotels.id = rooms.hotel_id JOIN bookings ON rooms.id = bookings.room_id GROUP BY hotels.location;
SELECT customers.name, MAX(bookings.total_price) AS highest_booking FROM customers JOIN bookings ON customers.id = bookings.customer_id GROUP BY customers.id ORDER BY highest_booking DESC LIMIT 5;
SELECT type, COUNT(*) AS count, AVG(price) AS average_price FROM rooms WHERE available = true GROUP BY type HAVING AVG(price) < 15000;
SELECT hotel_id, price AS total_revenue FROM rooms JOIN bookings ON rooms.id = bookings.room_id ;
SELECT customers.name, bookings.check_in_date, rooms.type FROM bookings JOIN customers ON bookings.customer_id = customers.id JOIN rooms ON bookings.room_id = rooms.id WHERE bookings.check_in_date BETWEEN '2022-01-04' AND '2022-12-31';
SELECT DISTINCT type FROM rooms WHERE available = false AND price > 10000;
SELECT bookings.id, customers.name, bookings.check_in_date, bookings.check_out_date FROM bookings JOIN customers ON bookings.customer_id = customers.id WHERE bookings.check_out_date > CURRENT_DATE ORDER BY bookings.check_out_date ASC;
SELECT hotel_id, COUNT(*) FILTER (WHERE type = 'Suite') AS suite_count FROM rooms GROUP BY hotel_id;
SELECT location, COUNT(*) AS hotel_count FROM hotels GROUP BY location ORDER BY hotel_count DESC;
SELECT name, phone FROM customers WHERE phone NOT LIKE '700-%' ORDER BY name;
SELECT rooms.hotel_id, AVG(rooms.price) FILTER (WHERE rooms.available = true) AS avg_available_room_price FROM rooms GROUP BY rooms.hotel_id;
SELECT bookings.room_id, COUNT(*) AS booking_count, AVG(bookings.total_price) AS avg_booking_price FROM bookings GROUP BY bookings.room_id HAVING COUNT(*) > 0;
SELECT type, MIN(price) AS cheapest_price FROM rooms WHERE available = true GROUP BY type ORDER BY cheapest_price ASC;
SELECT customers.id, customers.name, COUNT(bookings.id) AS bookings_count, SUM(bookings.total_price) AS total_expenditure FROM customers LEFT JOIN bookings ON customers.id = bookings.customer_id GROUP BY customers.id HAVING SUM(bookings.total_price) IS NOT NULL AND SUM(bookings.total_price) > 50000 ORDER BY total_expenditure DESC;
SELECT location, AVG(rating) AS average_rating FROM hotels GROUP BY location HAVING AVG(rating) >= 4.0 ORDER BY average_rating DESC;
SELECT type, COUNT(*) AS total_rooms, COUNT(*) FILTER (WHERE available = true) AS available_rooms FROM rooms GROUP BY type ORDER BY total_rooms DESC;
SELECT customers.email, COUNT(bookings.id) AS bookings_count FROM customers JOIN bookings ON customers.id = bookings.customer_id WHERE bookings.check_in_date > '2023-01-01' GROUP BY customers.email ORDER BY bookings_count DESC;
SELECT id, (SELECT COUNT(*) FROM rooms WHERE hotel_id = hotels.id AND available = true) AS available_room_count FROM hotels;
SELECT bookings.id AS booking_id, hotels.name AS hotel_name, rooms.type AS room_type FROM bookings JOIN rooms ON bookings.room_id = rooms.id JOIN hotels ON rooms.hotel_id = hotels.id WHERE bookings.total_price BETWEEN 100000 AND 200000 ORDER BY bookings.total_price DESC;
SELECT DISTINCT customers.name, bookings.check_in_date, bookings.check_out_date FROM bookings JOIN customers ON bookings.customer_id = customers.id WHERE bookings.check_in_date < CURRENT_DATE AND bookings.check_out_date > CURRENT_DATE ORDER BY bookings.check_in_date;
SELECT hotels.name, COUNT(rooms.id) AS room_count, AVG(rating) AS average_room_rating FROM hotels JOIN rooms ON hotels.id = rooms.hotel_id GROUP BY hotels.id ORDER BY average_room_rating DESC, room_count DESC;
SELECT rooms.type, AVG(bookings.total_price) AS avg_price_per_booking FROM rooms JOIN bookings ON rooms.id = bookings.room_id GROUP BY rooms.type HAVING AVG(bookings.total_price) > 10000;
SELECT customers.name, COUNT(DISTINCT bookings.id) AS bookings_count FROM customers JOIN bookings ON customers.id = bookings.customer_id JOIN rooms ON bookings.room_id = rooms.id WHERE rooms.type = 'Economy' GROUP BY customers.name ORDER BY bookings_count DESC;
SELECT hotels.name AS hotel_name, rooms.type AS room_type, COUNT(*) AS total_bookings FROM bookings JOIN rooms ON bookings.room_id = rooms.id JOIN hotels ON rooms.hotel_id = hotels.id GROUP BY hotels.name, rooms.type ORDER BY total_bookings DESC;
SELECT location, COUNT(DISTINCT id) AS hotel_count, SUM(rating) AS total_rating FROM hotels GROUP BY location ORDER BY hotel_count DESC, total_rating DESC;
SELECT rooms.hotel_id, rooms.type, COUNT(*) AS room_count, AVG(rooms.price) AS avg_price FROM rooms WHERE available = false GROUP BY rooms.hotel_id, rooms.type HAVING AVG(rooms.price) > 20000 ORDER BY avg_price DESC;
SELECT customers.name, bookings.check_in_date, bookings.check_out_date, rooms.type FROM bookings JOIN customers ON bookings.customer_id = customers.id JOIN rooms ON bookings.room_id = rooms.id WHERE rooms.type IN ('Deluxe', 'Suite') AND bookings.check_in_date BETWEEN '2023-01-01' AND '2023-12-31' ORDER BY bookings.check_in_date;
SELECT hotels.name, COUNT(*) AS number_of_rooms, SUM(CASE WHEN rooms.available THEN 1 ELSE 0 END) AS available_rooms, SUM(CASE WHEN rooms.available THEN 0 ELSE 1 END) AS booked_rooms FROM hotels JOIN rooms ON hotels.id = rooms.hotel_id GROUP BY hotels.name ORDER BY available_rooms DESC;
SELECT type, AVG(price) AS avg_price, COUNT(*) AS total_count FROM rooms WHERE available = true GROUP BY type HAVING COUNT(*) > 5 AND AVG(price) < 30000 ORDER BY avg_price ASC, total_count DESC;
SELECT hotel_id, COUNT(*) AS total_rooms, SUM(CASE WHEN available THEN 1 ELSE 0 END) AS available_rooms FROM rooms GROUP BY hotel_id HAVING SUM(CASE WHEN available THEN 1 ELSE 0 END) > 3 ORDER BY available_rooms DESC;
SELECT customers.name AS customer_name, bookings.total_price, rooms.type FROM customers JOIN bookings ON customers.id = bookings.customer_id JOIN rooms ON bookings.room_id = rooms.id WHERE bookings.total_price >= 10000 AND rooms.type = 'Suite' ORDER BY bookings.total_price DESC;
SELECT location, COUNT(*) AS hotel_count, AVG(rating) AS average_rating FROM hotels WHERE rating > 4 GROUP BY location ORDER BY average_rating DESC, hotel_count DESC;
SELECT rooms.type, COUNT(bookings.id) AS bookings_count, AVG(bookings.total_price) AS average_booking_price FROM rooms LEFT JOIN bookings ON rooms.id = bookings.room_id GROUP BY rooms.type ORDER BY bookings_count DESC, average_booking_price DESC;
SELECT hotel_id, COUNT(*) AS room_count, AVG(price) AS average_room_price, MIN(price) AS min_room_price, MAX(price) AS max_room_price FROM rooms GROUP BY hotel_id ORDER BY average_room_price DESC;
SELECT customers.name, COUNT(bookings.id) AS booking_count, AVG(bookings.total_price) AS average_spending_per_booking FROM customers JOIN bookings ON customers.id = bookings.customer_id GROUP BY customers.name ORDER BY average_spending_per_booking DESC, booking_count DESC;
SELECT rooms.type, COUNT(*) AS total_rooms, COUNT(*) FILTER (WHERE available = false) AS booked_rooms, AVG(price) AS average_price FROM rooms GROUP BY rooms.type ORDER BY total_rooms DESC, booked_rooms DESC;