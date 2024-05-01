from flask import Flask, request, jsonify
from app.models import Hotel, Room, Booking, Customer 
from app.__init__ import app


def response(success, message, status):
    return jsonify({"success": success, "message": message}), status


@app.route('/hotels', methods=['GET'])
def get_hotels():

    p_id = request.args.get('id')
    p_name = request.args.get('name')
    p_location = request.args.get('location')
    p_rating = request.args.get('rating')

    result = Hotel.get_hotels(p_id, p_name, p_location, p_rating)

    if not result:
        return response(False, "Failed to fetch from Hotels", 500)
    
    return jsonify(result), 200
    
@app.route('/hotels/<int:p_id>', methods=['GET'])
def get_hotel_by_id(p_id):
    result = Hotel.get_hotels(p_id)
    if not result:
        return response(False, "Failed to fetch from Hotels", 500)
    
    return jsonify(result), 200

@app.route('/hotels', methods=['POST'])
def insert_hotel():
    data = request.json

    if not data:
        return response(False, "Invalid data provided", 400)
       
    required_fields = ['name', 'location', 'rating']

    if not all(field in data for field in required_fields):
        return response(False, "Missing data for required fields", 400)
    
    result = Hotel.insert_hotel(data.get('name'), data.get('location'), data.get('rating'))

    if not result:
        return response(False, "Failed to insert Into Hotels", 500)
    
    return response(True, "Successfully inserted into Hotels", 201)

@app.route('/hotels/<int:p_id>', methods=['DELETE'])
def delete_hotel(p_id):
    result = Hotel.delete_hotel(p_id)

    if not result:
        return response(False, "Failed to delete Hotel", 500)

    return response(True, "Hotel has been deleted successfully", 200)

@app.route('/hotels/<int:p_id>', methods=['PUT'])
def update_hotel(p_id):
    data = request.json

    if not data:
        return response(False, "Invalid data provided", 400)

    required_fields = ['name', 'location', 'rating']

    if not all(field in data for field in required_fields):
        return response(False, "Missing data for required fields", 400)
    
    result = Hotel.update_hotel(p_id, data.get('name'), data.get('location'), data.get('rating'))

    if not result:
        return response(False, "Failed to update Hotels", 500)
    
    return response(True,  "Hotel has been updated successfully", 200)
    
@app.route('/rooms', methods=['GET'])
def get_rooms():
    p_id = request.args.get('id')
    p_hotel_id = request.args.get('hotel_id')
    p_type = request.args.get('type')
    p_price = request.args.get('price')
    p_available = request.args.get('available')

    result = Room.get_rooms(p_id, p_hotel_id, p_type, p_price, p_available)

    if not result:
        return response(False, "Failed to fetch from Rooms", 500)
    
    return jsonify(result), 200
    
@app.route('/rooms/<int:p_id>', methods=['GET'])
def get_room_by_id(p_id):
    result = Room.get_rooms(p_id)
    if not result:
        return response(False, "Failed to fetch from Rooms", 500)
    
    return jsonify(result), 200

@app.route('/rooms', methods=['POST'])
def insert_room():
    data = request.json

    if not data:
        return response(False, "Invalid data provided", 400)
       
    required_fields = ['hotel_id', 'type', 'available', 'price']

    if not all(field in data for field in required_fields):
        return response(False, "Missing data for required fields", 400)
    
    result = Room.insert_room(data.get('hotel_id'), data.get('type'), data.get('price'), data.get('available'))

    if not result:
        return response(False, "Failed to insert into Rooms", 500)
    
    return response(True, "Successfully inserted into Rooms", 201)

@app.route('/rooms/<int:p_id>', methods=['DELETE'])
def delete_room(p_id):
    result = Room.delete_room(p_id)

    if not result:
        return response(False, "Failed to delete hotel", 500)

    return response(True, "Room has been deleted successfully", 200)

@app.route('/rooms/<int:p_id>', methods=['PUT'])
def update_room(p_id):
    data = request.json

    if not data:
        return response(False, "Invalid data provided", 400)

    required_fields = ['hotel_id', 'type', 'available', 'price']

    if not all(field in data for field in required_fields):
        return response(False, "Missing data for required fields", 400)
    
    result = Room.update_room(p_id, data.get('hotel_id'), data.get('type'), data.get('price'), data.get('available'))

    if not result:
        return response(False, "Failed to update Rooms", 500)
    
    return response(False,  "Rooms has been updated successfully", 200)
    
@app.route('/customers', methods=['GET'])
def get_customers():
    p_id = request.args.get('id')
    p_name = request.args.get('name')
    p_email = request.args.get('email')
    p_phone = request.args.get('phone')

    result = Customer.get_customers(p_id, p_name, p_email, p_phone)

    if not result:
        return response(False, "Failed to fetch from Customers", 500)
    
    return jsonify(result), 200
    
@app.route('/customers/<int:p_id>', methods=['GET'])
def get_customer_by_id(p_id):
    result = Customer.get_customers(p_id)
    if not result:
        return response(False, "Failed to fetch from Customers", 500)
    
    return jsonify(result), 200

@app.route('/customers', methods=['POST'])
def insert_customer():
    data = request.json

    if not data:
        return response(False, "Invalid data provided", 400)
       
    required_fields = ['name', 'email', 'phone']

    if not all(field in data for field in required_fields):
        return response(False, "Missing data for required fields", 400)
    
    result = Customer.insert_customer(data.get('email'), data.get('name'), data.get('phone'))

    if not result:
        return response(False, "Failed to insert into Customers", 500)
    
    return response(True, "Successfully inserted into Customers", 201)

@app.route('/customers/<int:p_id>', methods=['DELETE'])
def delete_customer(p_id):
    result = Customer.delete_customer(p_id)

    if not result:
        return response(False, "Failed to delete customer", 500)

    return response(True, "Customer has been deleted successfully", 200)

@app.route('/customers/<int:p_id>', methods=['PUT'])
def update_customer(p_id):
    data = request.json

    if not data:
        return response(False, "Invalid data provided", 400)

    required_fields = ['name', 'email', 'phone']

    if not all(field in data for field in required_fields):
        return response(False, "Missing data for required fields", 400)
    
    result = Customer.update_customer(p_id, data.get('email'), data.get('name'), data.get('phone'))

    if not result:
        return response(False, "Failed to update Customers", 500)
    
    return response(False,  "Customers has been updated successfully", 200)




@app.route('/bookings', methods=['GET'])
def get_bookings():
    p_id = request.args.get('id')
    p_customer_id = request.args.get('customer_id')
    p_room_id = request.args.get('room_id')
    p_check_in_date = request.args.get('check_in_date')
    p_check_out_date = request.args.get('check_out_date')
    p_total_price = request.args.get('total_price')

    result = Booking.get_bookings(p_id, p_customer_id, p_room_id, p_check_in_date, p_check_out_date, p_total_price)

    if not result:
        return response(False, "Failed to fetch from Bookings", 500)
    
    return jsonify(result), 200
    
@app.route('/bookings/<int:p_id>', methods=['GET'])
def get_booking_by_id(p_id):
    result = Booking.get_bookings(p_id)
    if not result:
        return response(False, "Failed to fetch from Bookings", 500)
    
    return jsonify(result), 200

@app.route('/bookings', methods=['POST'])
def insert_booking():
    data = request.json

    if not data:
        return response(False, "Invalid data provided", 400)
       
    required_fields = [ 'customer_id', 'room_id', 'check_in_date', 'check_out_date', 'total_price' ]

    if not all(field in data for field in required_fields):
        return response(False, "Missing data for required fields", 400)
    
    result = Booking.insert_booking(data.get('customer_id'),
                                      data.get('room_id'), 
                                      data.get('check_in_date'), 
                                      data.get('check_out_date'), 
                                      data.get('total_price'))

    if not result:
        return response(False, "Failed to insert into Bookings", 500)
    
    return response(True, "Successfully inserted into Bookings", 201)

@app.route('/bookings/<int:p_id>', methods=['DELETE'])
def delete_booking(p_id):
    result = Booking.delete_booking(p_id)

    if not result:
        return response(False, "Failed to delete booking", 500)

    return response(True, "Bookings has been deleted successfully", 200)

@app.route('/bookings/<int:p_id>', methods=['PUT'])
def update_booking(p_id):
    data = request.json

    if not data:
        return response(False, "Invalid data provided", 400)

    required_fields = [ 'customer_id', 'room_id', 'check_in_date', 'check_out_date', 'total_price' ]

    if not all(field in data for field in required_fields):
        return response(False, "Missing data for required fields", 400)
    
    result = Booking.update_booking(p_id, 
                                      data.get('customer_id'),
                                      data.get('room_id'), 
                                      data.get('check_in_date'), 
                                      data.get('check_out_date'), 
                                      data.get('total_price'))

    if not result:
        return response(False, "Failed to update Booking", 500)
    
    return response(False,  "Booking has been updated successfully", 200)
    