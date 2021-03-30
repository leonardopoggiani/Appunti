# coding: utf-8

from __future__ import absolute_import

from flask import json
from six import BytesIO

from swagger_server.models.employee import Employee  # noqa: E501
from swagger_server.test import BaseTestCase


class TestEmployeesController(BaseTestCase):
    """EmployeesController integration test stubs"""

    def test_add_employee(self):
        """Test case for add_employee

        Add a new employee
        """
        body = Employee()
        response = self.client.open(
            '/v2/employees',
            method='POST',
            data=json.dumps(body),
            content_type='application/json')
        self.assert200(response,
                       'Response body is : ' + response.data.decode('utf-8'))

    def test_delete_employee(self):
        """Test case for delete_employee

        Deletes an employee
        """
        response = self.client.open(
            '/v2/employees/{employeeId}'.format(employeeId=789),
            method='DELETE')
        self.assert200(response,
                       'Response body is : ' + response.data.decode('utf-8'))

    def test_get_employee_by_id(self):
        """Test case for get_employee_by_id

        Find employee by ID
        """
        response = self.client.open(
            '/v2/employees/{employeeId}'.format(employeeId=789),
            method='GET')
        self.assert200(response,
                       'Response body is : ' + response.data.decode('utf-8'))

    def test_update_employee(self):
        """Test case for update_employee

        Update an existing employee
        """
        body = Employee()
        response = self.client.open(
            '/v2/employees',
            method='PUT',
            data=json.dumps(body),
            content_type='application/json')
        self.assert200(response,
                       'Response body is : ' + response.data.decode('utf-8'))

    def test_update_employee_with_form(self):
        """Test case for update_employee_with_form

        Updates an employee in the store with form data
        """
        data = dict(name='name_example',
                    status='status_example')
        response = self.client.open(
            '/v2/employees/{employeeId}'.format(employeeId=789),
            method='POST',
            data=data,
            content_type='application/x-www-form-urlencoded')
        self.assert200(response,
                       'Response body is : ' + response.data.decode('utf-8'))


if __name__ == '__main__':
    import unittest
    unittest.main()
