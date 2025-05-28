# Use Render’s official Python image
FROM python:3.11-slim

# Update package lists and install ffmpeg with retries and cleanup
RUN apt-get update --fix-missing && \
    apt-get install -y --no-install-recommends ffmpeg && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Copy and install Python dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of the application
COPY . .

# Command to run the bot
CMD ["python3", "-m", "main"]
