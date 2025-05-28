# Use Render’s official Python slim image
FROM python:3.11-slim

# Download and install a prebuilt ffmpeg binary
RUN apt-get update --fix-missing && apt-get install -y --no-install-recommends wget && \
    wget -O /tmp/ffmpeg.tar.xz https://johnvansickle.com/ffmpeg/releases/ffmpeg-release-amd64-static.tar.xz && \
    tar -C /tmp -xJf /tmp/ffmpeg.tar.xz && \
    mv /tmp/ffmpeg-*-amd64-static/ffmpeg /usr/local/bin/ && \
    mv /tmp/ffmpeg-*-amd64-static/ffprobe /usr/local/bin/ && \
    rm -rf /tmp/ffmpeg* && \
    apt-get remove -y wget && \
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
