# Use the official Python base image
FROM python:3.10-slim

# Install system dependencies required for TA-Lib
RUN apt-get update && \
    apt-get install -y build-essential wget && \
    wget http://prdownloads.sourceforge.net/ta-lib/ta-lib-0.4.0-src.tar.gz && \
    tar -xvzf ta-lib-0.4.0-src.tar.gz && \
    cd ta-lib && ./configure --prefix=/usr && make && make install

# Set the environment variable to find the TA-Lib libraries
ENV LD_LIBRARY_PATH="/usr/lib:$LD_LIBRARY_PATH"

# Set working directory
WORKDIR /app

# Copy the requirements.txt and install dependencies
COPY requirements.txt .
RUN pip install --upgrade pip
RUN pip install -r requirements.txt

# Copy the rest of the application code
COPY . /app

# Expose the port that Choreo expects to bind to
EXPOSE 5000

# Use Gunicorn to run the Flask app, binding to the specified port
CMD ["gunicorn", "app:app", "--bind", "0.0.0.0:5000"]
