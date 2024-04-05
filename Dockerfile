#Grab the latest alpine imag
FROM python:3.13.0a2-alpine

# Install python and pip
RUN apk add --no-cache --update python3 py3-pip bash
ADD ./website_karma-main/requirements.txt /tmp/requirements.txt

# Create a virtual environment and activate it
RUN python3 -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

# Install dependencies
RUN pip install --no-cache-dir -q -r /tmp/requirements.txt

# Add our code
ADD ./website_karma-main /opt/website_karma-main/
WORKDIR /opt/website_karma-main

# Expose is NOT supported by Heroku
# EXPOSE 5000         

# Run the image as a non-root user
RUN adduser -D myuser
USER myuser

# Run the app.  CMD is required to run on Heroku
# $PORT is set by Heroku            
CMD gunicorn --bind 0.0.0.0:$PORT wsgi