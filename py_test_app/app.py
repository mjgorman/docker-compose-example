
from flask import Flask
from flask import make_response
from redis import Redis
from socket import gethostname
import os
app = Flask(__name__)
redis = Redis(host='redis', port=6379)

@app.route('/')
def hello():
    redis.incr('hits')
    indexpage = 'Hello World! I have been seen %s times.' % redis.get('hits')
    resp = make_response(indexpage)
    resp.set_cookie('servername', gethostname())
    return resp

@app.route('/check')
def check():
    resp = make_response('OK')
    return resp


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=80, debug=True)
