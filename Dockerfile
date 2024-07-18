FROM python:3.11
WORKDIR /app
COPY requirements1.txt .
RUN pip install pip --upgrade
RUN apt-get update && apt-get install -y \
    libgirepository1.0-dev \
    && rm -rf /var/lib/apt/lists/*
RUN pip install --no-cache-dir -r requirements1.txt
COPY . .
CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]
