from flask import Flask, jsonify
import numpy as np
import talib

app = Flask(__name__)

@app.route('/')
def home():
  arr = np.array([1.1,1,1.3,13,4,3,4,34,43])
  arr_5 = talib.SMA(arr, timeperiod=5)
  return jsonify(arr_5.tolist())

if __name__ == '__main__':
  app.run(debug=True)
