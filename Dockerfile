# Set the python version as a build-time argument
# with Python 3.12 as the default
ARG PYTHON_VERSION=3.12-slim-bullseye
FROM python:${PYTHON_VERSION}

# Upgrade pip
RUN python -m pip install --upgrade pip

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# Create the code directory
RUN mkdir -p /code

# Set the working directory to that same code directory
WORKDIR /code

# Copy the requirements file into the container
COPY requirements.txt .

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy the entire project into the container
COPY src/ .

# Collect static files
RUN python manage.py collectstatic --noinput

# Expose the port that the Django app will run on
EXPOSE 8000

# Run the Django app
CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]










# # Set the python version as a build-time argument
# # with Python 3.12 as the default
# ARG PYTHON_VERSION=3.12-slim-bullseye
# FROM python:${PYTHON_VERSION}

# # Create a virtual environment
# RUN python -m venv /opt/venv

# # Set the virtual environment as the current location
# ENV PATH=/opt/venv/bin:$PATH

# # Upgrade pip
# RUN pip install --upgrade pip

# # Set Python-related environment variables
# ENV PYTHONDONTWRITEBYTECODE 1
# ENV PYTHONUNBUFFERED 1

# # Install os dependencies for our mini vm
# RUN apt-get update && apt-get install -y \
#     # for postgres
#     libpq-dev \
#     # for Pillow
#     libjpeg-dev \
#     # for CairoSVG
#     libcairo2 \
#     # other
#     gcc \
#     && rm -rf /var/lib/apt/lists/*

# # Create the mini vm's code directory
# RUN mkdir -p /code

# # Set the working directory to that same code directory
# WORKDIR /code

# # Copy the requirements file into the container
# COPY requirements.txt /tmp/requirements.txt

# # copy the project code into the container's working directory
# COPY ./src /code

# # Install the Python project requirements
# RUN pip install -r /tmp/requirements.txt
# # RUN pip install gunicorn

# ARG DJANGO_SECRET_KEY
# ENV DJANGO_SECRET_KEY=${DJANGO_SECRET_KEY}

# ARG DJANGO_DEBUG=0
# ENV DJANGO_DEBUG=${DJANGO_DEBUG}

# # database isn't available during build
# # run any other commands that do not need the database
# # such as:
# RUN python manage.py vendor_pull
# RUN python manage.py collectstatic --noinput
# # whitenoise -> s3

# # set the Django default project name
# ARG PROJ_NAME="abhihome"

# # create a bash script to run the Django project
# # this script will execute at runtime when
# # the container starts and the database is available
# RUN printf "#!/bin/bash\n" > ./paracord_runner.sh && \
#     printf "RUN_PORT=\"\${PORT:-8000}\"\n\n" >> ./paracord_runner.sh && \
#     printf "python manage.py migrate --no-input\n" >> ./paracord_runner.sh && \
#     printf "gunicorn ${PROJ_NAME}.wsgi:application --bind \"0.0.0.0:\$RUN_PORT\"\n" >> ./paracord_runner.sh

# # make the bash script executable
# RUN chmod +x paracord_runner.sh

# # Clean up apt cache to reduce image size
# RUN apt-get remove --purge -y \
#     && apt-get autoremove -y \
#     && apt-get clean \
#     && rm -rf /var/lib/apt/lists/*

# # Run the Django project via the runtime script
# # when the container starts
# CMD ./paracord_runner.sh