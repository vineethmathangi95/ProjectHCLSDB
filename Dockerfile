# -------- Stage 1: Build dependencies --------
FROM python:3.13.7 AS builder

WORKDIR /app

# Install build tools (only in builder)
RUN apt-get update && apt-get install -y \
    build-essential \
    gcc \
    && rm -rf /var/lib/apt/lists/*

# Copy requirements
COPY requirements.txt .

# Install dependencies into a custom directory
RUN pip install --no-cache-dir --prefix=/install -r requirements.txt


# -------- Stage 2: Final runtime image --------
FROM python:3.13.7-slim

WORKDIR /app

# Copy installed dependencies from builder
COPY --from=builder /install /usr/local

# Copy project code
COPY . .

# Expose port
EXPOSE 8000

# Run Django server
CMD ["python3", "manage.py", "runserver", "0.0.0.0:8000"]
