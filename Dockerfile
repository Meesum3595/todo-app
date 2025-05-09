# Use official Python image as base
FROM python:3.9-slim

# Prevent Python from writing pyc files and buffer stdout/stderr
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# Set work directory
WORKDIR /usr/src/app

# Install system dependencies and create non-root user
RUN apt-get update && apt-get install -y --no-install-recommends \
    gcc \
    libpq-dev \
    su-exec \
 && rm -rf /var/lib/apt/lists/* \
 # Create a non-root user and group
 && groupadd -r appuser \
 && useradd -r -g appuser -d /usr/src/app -s /sbin/nologin appuser

# Switch to non-root user
USER appuser

# Copy requirements file and install Python dependencies
COPY --chown=appuser:appuser requirements.txt .
RUN pip install --upgrade pip && pip install --no-cache-dir -r requirements.txt

# Copy application code
COPY --chown=appuser:appuser app ./app
COPY --chown=appuser:appuser instance ./instance
COPY --chown=appuser:appuser tests ./tests
COPY --chown=appuser:appuser run.py .

# Expose port 5000 for Flask
EXPOSE 5000

# Default command to run the Flask app
CMD ["python", "run.py"]
