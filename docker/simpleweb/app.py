import socket
from flask import Flask
app = Flask(__name__)

@app.route('/')
def hello_world():
    hostname = socket.gethostname()
    ip = socket.gethostbyname(hostname)
    return '{}: {}\n'.format(hostname, ip)