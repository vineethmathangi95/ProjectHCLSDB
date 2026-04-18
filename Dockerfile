# -------- Stage 1: Build dependencies --------
FROM python:3.13.7 AS builder

WORKDIR /app

RUN apt-get update && apt-get install -y \
    build-essential \
    gcc \
    default-libmysqlclient-dev \
    pkg-config \
    python3-dev \
    && rm -rf /var/lib/apt/lists/*

COPY requirements.txt .

RUN pip install --no-cache-dir --prefix=/install -r requirements.txt


# -------- Stage 2: Final runtime image --------
FROM python:3.13.7-slim

WORKDIR /app

# ✅ IMPORTANT: runtime MySQL client libs must exist here too
RUN apt-get update && apt-get install -y \
    default-libmysqlclient-dev \
    libmariadb3 \
    && rm -rf /var/lib/apt/lists/*

COPY --from=builder /install /usr/local
COPY . .

EXPOSE 8000

# optional but recommended for Django
ENV PYTHONUNBUFFERED=1

CMD ["python", "HclsPro/manage.py", "runserver", "0.0.0.0:8000"]
