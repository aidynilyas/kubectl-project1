from flask import Flask, jsonify

app = Flask(__name__)

@app.route("/")
def home():
    return jsonify({"message": "Book service is alive!"})

@app.route("/health")
def health():
    return "OK", 200

@app.route("/ready")
def ready():
    return "READY", 200

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
