#!flask/bin/python
from flask import Flask

from flask import jsonify

app = Flask(__name__)

employee = [
    {
        'id': 1,
        'name': u'Jhon',
        'picUrl': u'http://mypic.com' 
    },
    {
        'id': 2,
        'name': u'Pippo',
        'picUrl': u'http://myweb.com'
    }
]

@app.route('/v1/employees', methods=['GET'])
def get_employees():
    return jsonify(employee)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8080)
