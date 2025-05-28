# Use Render’s official Python slim image
FROM python:3.11-slim

# Set non-interactive frontend for apt-get to avoid prompts
ENV DEBIAN_FRONTEND=noninteractive

# Update package lists and install ffmpeg with retries and debugging
RUN apt-get update --fix-missing || (echo "apt-get update failed, retrying..." && apt-get update --fix-missing) && \
    apt-get install -y --no-install-recommends ffmpeg || (echo "apt-get install ffmpeg failed, listing available packages..." && apt list ffmpeg) && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Verify ffmpeg installation
RUN ffmpeg -version || (echo "ffmpeg installation failed" && exit 1)

# Set working directory
WORKDIR /app

# Copy and install Python dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of the application
COPY . .

# Command to run the bot
CMD ["python3", "-m", "main"]
