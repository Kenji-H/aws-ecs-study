from flask import Flask
import time

app = Flask(__name__)

@app.route('/')
def hello():
    name = "Hello World"
    return name

@app.route('/heavy_task/<int:wait_millis>')
def heavy_task(wait_millis):
    time.sleep(wait_millis / 1000)
    name = f"Hello Heavy Task: {wait_millis}ms"
    return name

if __name__ == "__main__":
    app.run(debug=False, host='0.0.0.0')
