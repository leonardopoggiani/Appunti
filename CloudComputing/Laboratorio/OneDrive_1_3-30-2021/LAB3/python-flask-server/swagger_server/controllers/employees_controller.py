import connexion
import six

from swagger_server.models.employee import Employee  # noqa: E501
from swagger_server import util

from flask import jsonify
import MySQLdb

def add_employee(body):  # noqa: E501
    """Add a new employee

     # noqa: E501

    :param body: Employee data
    :type body: dict | bytes

    :rtype: None
    """
    if connexion.request.is_json:
        body = Employee.from_dict(connexion.request.get_json())  # noqa: E501
        print(body.name)
        print(str(body.id))

        mydb = MySQLdb.connect(host="172.17.0.4", user="root",passwd="password", db="company")

        print(mydb)

        mycursor = mydb.cursor()

        sql = "INSERT INTO employees (id, name, picUrl) VALUES (%s, %s, %s)"
        val = (body.id, body.name, body.photo_urls)

        print(val)

        mycursor.execute(sql, val)

        mydb.commit()

    return 'do some magic!'


def delete_employee(employeeId):  # noqa: E501
    """Deletes an employee

     # noqa: E501

    :param employeeId: Employee id to delete
    :type employeeId: int

    :rtype: None
    """
    return 'do some magic!'


def get_employee_by_id(employeeId):  # noqa: E501
    """Find employee by ID

    Returns a single employee # noqa: E501

    :param employeeId: ID of Employee to return
    :type employeeId: int

    :rtype: Employee
    """

    mydb = MySQLdb.connect(host="172.17.0.4", user="root",passwd="password", db="company")

    mycursor = mydb.cursor()

    sql = "SELECT * FROM employees WHERE id='{}'".format(employeeId)

    print(sql)

    mycursor.execute(sql)

    myresult = mycursor.fetchall()

    print(myresult)

    return jsonify(name=myresult[0][1],
                   picUrl=myresult[0][2],
                   id=myresult[0][0])

    #return "{ 'id': {}, 'name': {}, photoUrl: {} }".format(myresult[0][0], myresult[0][1], myresult[0][2])


def update_employee(body):  # noqa: E501
    """Update an existing employee

     # noqa: E501

    :param body: Employee object that needs to be added to the store
    :type body: dict | bytes

    :rtype: None
    """
    if connexion.request.is_json:
        body = Employee.from_dict(connexion.request.get_json())  # noqa: E501
    return 'do some magic!'


def update_employee_with_form(employeeId, name=None, status=None):  # noqa: E501
    """Updates an employee in the store with form data

     # noqa: E501

    :param employeeId: ID of employe that needs to be updated
    :type employeeId: int
    :param name: Updated name of the employee
    :type name: str
    :param status: Updated status of the employee
    :type status: str

    :rtype: None
    """
    return 'do some magic!'
