import psycopg2
from psycopg2.extras import RealDictCursor
from psycopg2 import Error

class Database:
    @staticmethod
    def get_db_connection():
        try:
            conn = psycopg2.connect(
                dbname='db2024',
                user='db2024_admin',
                password='252525',
                host='localhost',
                port='5432'
            )
            return conn
        except Error as e:
            print(e)