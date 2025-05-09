# Use official Python image as base
FROM python:3.9-slim

# Prevent Python from writing pyc files and buffer stdout/stderr
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Set working directory
WORKDIR /usr/src/app

# Install system dependencies and create non-root user\RUN apt-get update \
    && apt-get install -y --no-install-recommends \
       gcc \
       libpq-dev \
    && rm -rf /var/lib/apt/lists/* \
    && groupadd -r appuser \
    && useradd -r -g appuser -d /usr/src/app -s /usr/sbin/nologin appuser

# Copy requirements file and install Python dependencies as root
COPY requirements.txt ./
RUN pip install --upgrade pip \
    && pip install --no-cache-dir -r requirements.txt

# Copy application code and set ownership to non-root user
COPY . ./
RUN chown -R appuser:appuser /usr/src/app

# Switch to non-root user
USER appuser

# Expose port 5000 for Flask
EXPOSE 5000

# Default command to run the Flask app
CMD ["python", "run.py"]
