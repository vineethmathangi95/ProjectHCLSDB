# -------- Stage 1: Build dependencies --------
FROM python:3.13.7 AS builder

WORKDIR /app

RUN apt-get update && apt-get install -y \
    build-essential \
    gcc \
    && rm -rf /var/lib/apt/lists/*

COPY requirements.txt .

RUN pip install --no-cache-dir --prefix=/install -r requirements.txt


# -------- Stage 2: Final runtime image --------
FROM python:3.13.7-slim

WORKDIR /app

COPY --from=builder /install /usr/local
COPY . .

EXPOSE 8000

# ✅ FIX: correct path to manage.py
CMD ["python3", "HclsPro/manage.py", "runserver", "0.0.0.0:8000"]
