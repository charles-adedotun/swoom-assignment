from flask import Flask, request
import logging

app = Flask(__name__)

# Configure logging
logging.basicConfig(level=logging.INFO)
stream_handler = logging.StreamHandler()
stream_handler.setLevel(logging.INFO)
app.logger.addHandler(stream_handler)

@app.route('/')
def hello_world():
    app.logger.info("Hello world endpoint was accessed")
    return "Hello Graylog, my name is Charles!", 200, {'Content-Type': 'text/plain'}

@app.route('/health')
def health_check():
    return "healthy", 200, {'Content-Type': 'text/plain'}

@app.errorhandler(404)
def page_not_found(e):
    app.logger.error(f"Page not found: {request.url}")
    return "404 page not found", 404, {'Content-Type': 'text/plain'}

@app.errorhandler(500)
def internal_server_error(e):
    app.logger.critical("Internal server error encountered")
    return "500 internal server error", 500, {'Content-Type': 'text/plain'}

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5001)
