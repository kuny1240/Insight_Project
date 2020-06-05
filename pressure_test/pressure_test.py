import mysql.connector
import os
from mysql.connector import errorcode

import random
import string
import time

def randomString(stringLength=10):
    """Generate a random string of fixed length """
    letters = string.ascii_lowercase
    return ''.join(random.choice(letters) for i in range(stringLength))

if os.environ['RDS_HOSTMASTER'] != None:
    username = os.environ['RDS_Username']
    password = os.environ['RDS_PASSWORD']
    host = os.environ['RDS_HOSTMASTER']
    read1 = os.environ['RDS_HOSTREAD']
    read2 = os.environ['RDS_HOSTREAD2']





DB_NAME = 'pressure_test'
OPTIONS = {}
OPTIONS['insert'] = "INSERT INTO users (user_name) VALUES ('{}')"
OPTIONS['query'] = "SELECT user_name FROM users WHERE user_name LIKE 'k%'"





counter = 0
# cnx = mysql.connector.connect(user=username, password=password,
#                                   host=host, port=3306, database=DB_NAME)
cnx_read = mysql.connector.connect(host = read2,port = 3306, database = DB_NAME,
                                       user = username, password=password)
while True:

    # cursor = cnx.cursor()
    cursor_read = cnx_read.cursor(buffered=True)
    data_test = randomString(10)
    # cursor.execute(OPTIONS['insert'].format(data_test))
    cursor_read.execute(OPTIONS['query'])

    if counter < 200:
        time.sleep(0.01)
    elif counter > 5000:
        break


    # cnx.commit()
    cnx_read.commit()
    print('Inserted {}'.format(data_test))



    counter += 1

# cursor.close()
cursor_read.close()
# cnx.close()
cnx_read.close()

print('Test Ended!')



