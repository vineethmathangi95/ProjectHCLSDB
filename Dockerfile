FROM python:3.13.7-slim

WORKDIR /app

# ---- System dependencies (MySQL + build tools) ----
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    gcc \
    pkg-config \
    default-libmysqlclient-dev \
    python3-dev \
    && rm -rf /var/lib/apt/lists/*

# ---- Python dependencies ----
COPY requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

# ---- Copy project ----
COPY . .

EXPOSE 8000

ENV PYTHONUNBUFFERED=1

# ---- Run Django ----
CMD ["python", "HclsPro/manage.py", "runserver", "0.0.0.0:8000"]
