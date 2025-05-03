FROM python:3.10-slim

# Install TA-Lib C library
RUN apt-get update && \
    apt-get install -y build-essential wget && \
    wget http://prdownloads.sourceforge.net/ta-lib/ta-lib-0.4.0-src.tar.gz && \
    tar -xvzf ta-lib-0.4.0-src.tar.gz && \
    cd ta-lib && ./configure --prefix=/usr && make && make install

ENV LD_LIBRARY_PATH="/usr/lib:$LD_LIBRARY_PATH"

# Install Python dependencies
COPY requirements.txt .
RUN pip install --upgrade pip
RUN pip install -r requirements.txt

COPY . /app
WORKDIR /app

CMD ["gunicorn", "app:app", "--bind", "0.0.0.0:8000"]
