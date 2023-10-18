# Use an official Python runtime as the parent image
FROM python:3.11-slim

# Set the working directory in the container
WORKDIR /app

# Create a non-root user with a home directory and switch to it
RUN useradd -m myuser && chown -R myuser /app
USER myuser

# Copy only the necessary files into the container at /app
COPY main.py requirements.txt ./

# Install any needed packages specified in requirements.txt
RUN pip install --no-cache-dir -r requirements.txt --user

# Make port 5001 available to the world outside this container
EXPOSE 5001

# Set environment variables
ENV PATH=$PATH:/home/myuser/.local/bin

# Run main.py when the container launches
CMD ["gunicorn", "-b", "0.0.0.0:5001", "main:app"]
