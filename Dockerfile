FROM python:3.10-slim

# Install system dependencies
RUN apt-get update && \
    apt-get install -y build-essential wget && \
    wget http://prdownloads.sourceforge.net/ta-lib/ta-lib-0.4.0-src.tar.gz && \
    tar -xvzf ta-lib-0.4.0-src.tar.gz && \
    cd ta-lib && ./configure --prefix=/usr && make && make install && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

ENV LD_LIBRARY_PATH="/usr/lib:$LD_LIBRARY_PATH"

# Create a non-root user
RUN useradd -m appuser

# Set working directory
WORKDIR /app

# Copy and install Python dependencies
COPY requirements.txt .
RUN pip install --upgrade pip && pip install -r requirements.txt

# Copy application code
COPY . .

# Switch to non-root user
USER appuser

# Expose port (optional)
EXPOSE 5000

# Run the app
CMD ["gunicorn", "app:app", "--bind", "0.0.0.0:5000"]
