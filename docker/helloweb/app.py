import os
import socket

from flask import Flask
from redis import Redis, RedisError

redis = Redis(host=os.getenv("REDIS_HOST", "redis"), db=0)

app = Flask(__name__)

@app.route("/")
def hello():
    try:
        visits = redis.incr("counter")
    except RedisError:
        visits = "<i>Cannot connect to Redis, counter disabled</i>"

    html = "<h3 style='color: blue;'>Hello {name}!</h3>" \
           "<p>Hostname:<b style='color: red;'> {hostname}</b></p>" \
           "<p>IP:<b style='color: green;'> {ip}</b></p>" \
           "<p>Visits: {visits}</p>" \
           "<p>Version: 1.0</p>"
    hostname = socket.gethostname()
    ip = socket.gethostbyname(hostname)
    return html.format(name=os.getenv("NAME", "world"), hostname=hostname, ip=ip, visits=visits)


if __name__ == "__main__":
    app.run(host='0.0.0.0', port=8000)
