from flask import Flask, render_template
import os

app = Flask(__name__)

counter = 0

@app.route('/')
def home():
	global counter
	counter+=1
	return "hello world app2 " + str(counter)


if __name__ == "__main__":
	counter = 0
	port = int(os.environ.get('PORT', 4000))
	app.run(debug=True, host='0.0.0.0', port=port)