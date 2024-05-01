SET search_path to db2024;
CREATE OR REPLACE FUNCTION get_hotels(
    p_id INT DEFAULT NULL,
    p_name VARCHAR DEFAULT NULL,
    p_location VARCHAR DEFAULT NULL,
    p_rating DECIMAL DEFAULT NULL
)
RETURNS TABLE(id INT, name VARCHAR, location VARCHAR, rating DECIMAL)
LANGUAGE plpgsql AS $$
BEGIN
    RETURN QUERY 
    SELECT h.id, h.name, h.location, h.rating 
    FROM db2024.hotels AS h
    WHERE (p_id IS NULL OR h.id = p_id) 
    AND (p_name IS NULL OR h.name = p_name) 
    AND (p_location IS NULL OR h.location = p_location) 
    AND (p_rating IS NULL OR h.rating = p_rating);
END;
$$;

CREATE OR REPLACE FUNCTION get_rooms(
    p_id INT DEFAULT NULL,
    p_hotel_id INT DEFAULT NULL,
	p_type VARCHAR DEFAULT NULL,
	p_price DECIMAL DEFAULT NULL,
	p_available BOOLEAN DEFAULT NULL
)
RETURNS TABLE(id INT, hotel_id INT, type VARCHAR, price DECIMAL, available BOOLEAN)
LANGUAGE plpgsql AS $$
BEGIN
    RETURN QUERY 
    SELECT r.id, r.hotel_id, r.type, r.price, r.available 
    FROM db2024.rooms AS r
    WHERE (p_id IS NULL OR r.id = p_id)
    AND (p_hotel_id IS NULL OR r.hotel_id = p_hotel_id)
	AND (p_type IS NULL OR r.type = p_type)
	AND (p_price IS NULL OR r.price = p_price)
	AND (p_available IS NULL OR r.available = p_available);
END;
$$;

CREATE OR REPLACE FUNCTION get_customers(
    p_id INT DEFAULT NULL,
    p_email VARCHAR DEFAULT NULL,
	p_name VARCHAR DEFAULT NULL,
	p_phone VARCHAR DEFAULT NULL
)
RETURNS TABLE(id INT, name VARCHAR, email VARCHAR, phone VARCHAR)
LANGUAGE plpgsql AS $$
BEGIN
    RETURN QUERY 
    SELECT cu.id, cu.name, cu.email, cu.phone 
    FROM db2024.customers AS cu
    WHERE (p_id IS NULL OR cu.id = p_id)
    AND (p_email IS NULL OR cu.email = p_email)
	AND (p_name IS NULL OR cu.name = p_name)
	AND (p_phone IS NULL OR cu.phone = p_phone);
END;
$$;

CREATE OR REPLACE FUNCTION get_bookings(
    p_id INT DEFAULT NULL,
    p_customer_id INT DEFAULT NULL,
    p_room_id INT DEFAULT NULL,
	p_check_in_date DATE DEFAULT NULL,
	p_check_out_date DATE DEFAULT NULL,
	p_total_price DECIMAL DEFAULT NULL
)
RETURNS TABLE(id INT, customer_id INT, room_id INT, check_in_date DATE, check_out_date DATE, total_price DECIMAL)
LANGUAGE plpgsql AS $$
BEGIN
    RETURN QUERY SELECT b.id, b.customer_id, b.room_id, b.check_in_date, b.check_out_date, b.total_price 
    FROM db2024.bookings AS b
    WHERE (p_id IS NULL OR b.id = p_id)
    AND (p_customer_id IS NULL OR b.customer_id = p_customer_id)
    AND (p_room_id IS NULL OR b.room_id = p_room_id)
	AND (p_check_in_date IS NULL OR b.check_in_date = p_check_in_date)
	AND (p_check_out_date IS NULL OR b.check_out_date = p_check_out_date)
	AND (p_total_price IS NULL OR b.total_price = p_total_price);
END;
$$;


CREATE OR REPLACE PROCEDURE update_hotel(
    p_id INT,
    p_name VARCHAR DEFAULT NULL,
    p_location VARCHAR DEFAULT NULL,
    p_rating DECIMAL DEFAULT NULL
)
LANGUAGE plpgsql AS $$
BEGIN
    EXECUTE format('UPDATE db2024.hotels SET %s WHERE id = $1', 
        trim(both ',' from 
            concat_ws(',', 
                CASE WHEN p_name IS NOT NULL THEN format('name = %L', p_name) END,
                CASE WHEN p_location IS NOT NULL THEN format('location = %L', p_location) END,
                CASE WHEN p_rating IS NOT NULL THEN format('rating = %L', p_rating) END
            )
        )
    )
    USING p_id;
END;
$$;

CREATE OR REPLACE PROCEDURE update_room(
    p_id INT, 
    p_hotel_id INT DEFAULT NULL, 
    p_type VARCHAR DEFAULT NULL, 
    p_price DECIMAL DEFAULT NULL, 
    p_available BOOLEAN DEFAULT NULL
)
LANGUAGE plpgsql AS $$
BEGIN
    EXECUTE format('UPDATE db2024.rooms SET %s WHERE id = $1', 
        trim(both ',' from 
            concat_ws(',', 
                CASE WHEN p_hotel_id IS NOT NULL THEN format('hotel_id = %L', p_hotel_id) END,
                CASE WHEN p_type IS NOT NULL THEN format('type = %L', p_type) END,
                CASE WHEN p_price IS NOT NULL THEN format('price = %L', p_price) END,
                CASE WHEN p_available IS NOT NULL THEN format('available = %L', p_available) END
            )
        )
    )
    USING p_id;
END;
$$;

CREATE OR REPLACE PROCEDURE update_customer(
    p_id INT, 
    p_name VARCHAR DEFAULT NULL, 
    p_email VARCHAR DEFAULT NULL, 
    p_phone VARCHAR DEFAULT NULL
)
LANGUAGE plpgsql AS $$
BEGIN
    EXECUTE format('UPDATE db2024.customers SET %s WHERE id = $1', 
        trim(both ',' from 
            concat_ws(',', 
                CASE WHEN p_name IS NOT NULL THEN format('name = %L', p_name) END,
                CASE WHEN p_email IS NOT NULL THEN format('email = %L', p_email) END,
                CASE WHEN p_phone IS NOT NULL THEN format('phone = %L', p_phone) END
            )
        )
    )
    USING p_id;
END;
$$;

CREATE OR REPLACE PROCEDURE update_booking(
    p_id INT, 
    p_customer_id INT DEFAULT NULL, 
    p_room_id INT DEFAULT NULL, 
    p_check_in_date DATE DEFAULT NULL, 
    p_check_out_date DATE DEFAULT NULL, 
    p_total_price DECIMAL DEFAULT NULL
)
LANGUAGE plpgsql AS $$
DECLARE
    v_current_check_in DATE;
    v_current_check_out DATE;
BEGIN
    SELECT b.check_in_date, b.check_out_date INTO v_current_check_in, v_current_check_out
    FROM bookings AS b WHERE id = p_id;
    
    IF p_check_in_date IS NOT NULL AND p_check_out_date IS NOT NULL THEN
        IF p_check_in_date > p_check_out_date THEN
            RAISE EXCEPTION 'Check-in date cannot be later than check-out date';
        END IF;
    ELSIF p_check_in_date IS NOT NULL THEN
        IF p_check_in_date > v_current_check_out THEN
            RAISE EXCEPTION 'Check-in date cannot be later than current check-out date';
        END IF;
    ELSIF p_check_out_date IS NOT NULL THEN
        IF v_current_check_in > p_check_out_date THEN
            RAISE EXCEPTION 'Current check-in date cannot be later than check-out date';
        END IF;
    END IF;
    
    EXECUTE format('UPDATE db2024.bookings SET %s WHERE id = $1', 
        trim(both ',' from 
            concat_ws(',', 
                CASE WHEN p_customer_id IS NOT NULL THEN format('customer_id = %L', p_customer_id) END,
                CASE WHEN p_room_id IS NOT NULL THEN format('room_id = %L', p_room_id) END,
                CASE WHEN p_check_in_date IS NOT NULL THEN format('check_in_date = %L', p_check_in_date) ELSE format('check_in_date = %L', v_current_check_in) END,
                CASE WHEN p_check_out_date IS NOT NULL THEN format('check_out_date = %L', p_check_out_date) ELSE format('check_out_date = %L', v_current_check_out) END,
                CASE WHEN p_total_price IS NOT NULL THEN format('total_price = %L', p_total_price) END
            )
        )
    )
    USING p_id;
END;
$$;

CREATE OR REPLACE PROCEDURE delete_hotel(p_id INT)
LANGUAGE plpgsql AS $$
BEGIN
    DELETE FROM db2024.hotels WHERE id = p_id;
END;
$$;

CREATE OR REPLACE PROCEDURE delete_room(p_id INT)
LANGUAGE plpgsql AS $$
BEGIN
    DELETE FROM db2024.rooms WHERE id = p_id;
END;
$$;

CREATE OR REPLACE PROCEDURE delete_customer(p_id INT)
LANGUAGE plpgsql AS $$
BEGIN
    DELETE FROM db2024.customers WHERE id = p_id;
END;
$$;

CREATE OR REPLACE PROCEDURE delete_booking(p_id INT)
LANGUAGE plpgsql AS $$
BEGIN
    DELETE FROM db2024.bookings WHERE id = p_id;
END;
$$;
CREATE OR REPLACE PROCEDURE insert_hotel(IN p_name VARCHAR(255), IN p_location VARCHAR(255), IN p_rating DECIMAL(5,2))
LANGUAGE plpgsql
AS $$
BEGIN
  INSERT INTO db2024.hotels (name, location, rating) VALUES (p_name, p_location, p_rating);
END;
$$;
COMMENT ON PROCEDURE insert_hotel IS 'Adds hotel to "hotels" table';
CREATE OR REPLACE PROCEDURE insert_room(
    p_hotel_id INTEGER,
    p_type VARCHAR(50),
    p_price DECIMAL(10,1),
    p_available BOOLEAN
)
LANGUAGE plpgsql
AS $$
BEGIN
    IF EXISTS(SELECT 1 FROM db2024.hotels AS h WHERE h.id = p_hotel_id) THEN
        INSERT INTO db2024.rooms (hotel_id, type, price, available)
        VALUES (p_hotel_id, p_type, p_price, p_available);
    ELSE
        RAISE EXCEPTION 'Hotel with id % does not exist', p_hotel_id;
    END IF;
END;
$$;
COMMENT ON PROCEDURE insert_room IS 'Adds room to "rooms" table if specified hotel exists';
CREATE OR REPLACE PROCEDURE insert_booking(IN p_customer_id integer, IN p_room_id integer, IN p_check_in_date date, IN p_check_out_date date, IN p_total_price numeric)
 LANGUAGE plpgsql
AS $$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM db2024.customers AS cu WHERE cu.id = p_customer_id) THEN
        RAISE EXCEPTION 'Customer with id % does not exist', p_customer_id;
    END IF;
    
    IF NOT EXISTS(SELECT 1 FROM db2024.rooms AS r WHERE r.id = p_room_id) THEN
        RAISE EXCEPTION 'Room with id % does not exist', p_room_id;
    END IF;
    
    INSERT INTO db2024.bookings (customer_id, room_id, check_in_date, check_out_date, total_price)
    VALUES (p_customer_id, p_room_id, p_check_in_date, p_check_out_date, p_total_price);
END;
$$;
COMMENT ON PROCEDURE insert_booking IS 'Adds booking to "bookings" table if specified customer and room exists';

DROP PROCEDURE insert_customer;
CREATE OR REPLACE PROCEDURE insert_customer(IN p_name character varying, IN p_email character varying, IN p_phone character varying)
 LANGUAGE plpgsql
AS $$
BEGIN
    IF EXISTS(SELECT 1 FROM db2024.customers AS cu WHERE cu.email = p_email) THEN
        RAISE EXCEPTION 'Customer with email % already exists', p_email;
    ELSE
        INSERT INTO db2024.customers (name, email, phone)
        VALUES (p_name, p_email, p_phone);
    END IF;
END;
$$;
COMMENT ON PROCEDURE insert_customer IS 'Adds customer to "customers" table if specified email doe`s not exist';