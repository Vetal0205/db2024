from psycopg2.extras import RealDictCursor
from app.db import Database
from psycopg2 import Error

class Hotel:
    @staticmethod
    def get_hotels(p_id=None, p_name=None, p_location=None, p_rating=None):
        try:
            with Database.get_db_connection() as conn, conn.cursor(cursor_factory=RealDictCursor) as cur:
                cur.execute("SELECT db2024.get_hotels(%s, %s, %s, %s);", (p_id, p_name, p_location, p_rating))
                result = cur.fetchall()
                return result
        except Error as e:
            print(e)
            return False


    @staticmethod
    def insert_hotel(p_name, p_location, p_rating):
        try:
            with Database.get_db_connection() as conn, conn.cursor(cursor_factory=RealDictCursor) as cur:
                cur.execute("CALL db2024.insert_hotel(%s, %s, %s);", (p_name, p_location, p_rating))
                conn.commit()
                return True 
        except Error as e:
            print(e)
            return False

    @staticmethod
    def delete_hotel(p_id):
        try:
            with Database.get_db_connection() as conn, conn.cursor(cursor_factory=RealDictCursor) as cur:
                cur.execute("CALL db2024.delete_hotel(%s);", (p_id,))
                conn.commit()
                return True
        except Error as e:
            print(e)
            return False
                      
    @staticmethod
    def update_hotel(p_id, p_name, p_location, p_rating):
        try:
            with Database.get_db_connection() as conn, conn.cursor(cursor_factory=RealDictCursor) as cur:
                cur.execute("CALL db2024.update_hotel(%s, %s, %s, %s);", (p_id, p_name, p_location, p_rating))
                conn.commit()
                return True
        except Error as e:
            print(e)
            return False
        
class Booking:
    @staticmethod
    def get_bookings(p_id=None, p_customer_id=None, p_room_id=None, p_check_in_date=None, p_check_out_date=None, p_total_price=None):
        try:
            with Database.get_db_connection() as conn, conn.cursor(cursor_factory=RealDictCursor) as cur:
                cur.execute("SELECT db2024.get_bookings(%s, %s, %s, %s, %s, %s);", (p_id, p_customer_id, p_room_id, p_check_in_date, p_check_out_date, p_total_price))
                result = cur.fetchall()
                return result
        except Error as e:
            print(e)
            return False

    @staticmethod
    def insert_booking(p_customer_id, p_room_id, p_check_in_date, p_check_out_date, p_total_price):
        try:
            with Database.get_db_connection() as conn, conn.cursor(cursor_factory=RealDictCursor) as cur:
                cur.execute("CALL db2024.insert_booking(%s, %s, %s, %s, %s);", (p_customer_id, p_room_id, p_check_in_date, p_check_out_date, p_total_price))
                conn.commit()
                return True 
        except Error as e:
            print(e)
            return False

    @staticmethod
    def delete_booking(p_id):
        try:
            with Database.get_db_connection() as conn, conn.cursor(cursor_factory=RealDictCursor) as cur:
                cur.execute("CALL db2024.delete_booking(%s);", (p_id,))
                conn.commit()
                return True
        except Error as e:
            print(e)
            return False
                      
    @staticmethod
    def update_booking(p_id, p_customer_id, p_room_id, p_check_in_date, p_check_out_date, p_total_price):
        try:
            with Database.get_db_connection() as conn, conn.cursor(cursor_factory=RealDictCursor) as cur:
                cur.execute("CALL db2024.update_booking(%s, %s, %s, %s, %s, %s);", (p_id, p_customer_id, p_room_id, p_check_in_date, p_check_out_date, p_total_price))
                conn.commit()
                return True
        except Error as e:
            print(e)
            return False
        
class Room:
    @staticmethod
    def get_rooms(p_id=None, p_hotel_id=None, p_type=None, p_price=None, p_available=None):
        try:
            with Database.get_db_connection() as conn, conn.cursor(cursor_factory=RealDictCursor) as cur:
                cur.execute("SELECT db2024.get_rooms(%s, %s, %s, %s, %s);", (p_id, p_hotel_id, p_type, p_price, p_available))
                result = cur.fetchall()
                return result
        except Error as e:
            print(e)
            return False


    @staticmethod
    def insert_room(p_hotel_id, p_type, p_price, p_available):
        try:
            with Database.get_db_connection() as conn, conn.cursor(cursor_factory=RealDictCursor) as cur:
                cur.execute("CALL db2024.insert_room(%s, %s, %s, %s);", (p_hotel_id, p_type, p_price, p_available))
                conn.commit()
                return True 
        except Error as e:
            print(e)
            return False

    @staticmethod
    def delete_room(p_id):
        try:
            with Database.get_db_connection() as conn, conn.cursor(cursor_factory=RealDictCursor) as cur:
                cur.execute("CALL db2024.delete_room(%s);", (p_id,))
                conn.commit()
                return True
        except Error as e:
            print(e)
            return False
                      
    @staticmethod
    def update_room(p_id, p_hotel_id, p_type, p_price, p_available):
        try:
            with Database.get_db_connection() as conn, conn.cursor(cursor_factory=RealDictCursor) as cur:
                cur.execute("CALL db2024.update_room(%s, %s, %s, %s, %s);", (p_id, p_hotel_id, p_type, p_price, p_available))
                conn.commit()
                return True
        except Error as e:
            print(e)
            return False
        
class Customer:
    @staticmethod
    def get_customers(p_id=None, p_email=None, p_name=None, p_phone=None):
        try:
            with Database.get_db_connection() as conn, conn.cursor(cursor_factory=RealDictCursor) as cur:
                cur.execute("SELECT db2024.get_customers(%s, %s, %s, %s);", (p_id, p_email, p_name, p_phone))
                result = cur.fetchall()
                return result
        except Error as e:
            print(e)
            return False


    @staticmethod
    def insert_customer(p_email, p_name, p_phone):
        try:
            with Database.get_db_connection() as conn, conn.cursor(cursor_factory=RealDictCursor) as cur:
                cur.execute("CALL db2024.insert_customer(%s, %s, %s);", (p_email, p_name, p_phone))
                conn.commit()
                return True 
        except Error as e:
            print(e)
            return False

    @staticmethod
    def delete_customer(p_id):
        try:
            with Database.get_db_connection() as conn, conn.cursor(cursor_factory=RealDictCursor) as cur:
                cur.execute("CALL db2024.delete_customer(%s);", (p_id,))
                conn.commit()
                return True
        except Error as e:
            print(e)
            return False
                      
    @staticmethod
    def update_customer(p_id, p_email, p_name, p_phone):
        try:
            with Database.get_db_connection() as conn, conn.cursor(cursor_factory=RealDictCursor) as cur:
                cur.execute("CALL db2024.update_customer(%s, %s, %s, %s);", (p_id, p_email, p_name, p_phone))
                conn.commit()
                return True
        except Error as e:
            print(e)
            return False