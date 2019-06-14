import os
import socket

from flask import Flask
from redis import Redis, RedisError

redis = Redis(host=os.getenv("REDIS_HOST", "redis"), db=0 )

app = Flask(__name__)

@app.route("/")
def hello():
    try:
        num = redis.incr("counter")
    except RedisError:
        num = "-1"

    html = "<h2>Hello {} ~</h2>" \
            "No. {} greetings from: <b>{}</b>"
    return html.format(os.getenv("WHO", "world"), num, socket.gethostname())

if __name__ == "__main__":
    app.run(host='0.0.0.0', port=80)
