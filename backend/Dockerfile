FROM python:3.10

# set the working directory
WORKDIR /app

# install dependencies
COPY ./requirements.txt /app
RUN pip install --no-cache-dir --upgrade -r requirements.txt

# copy the scripts to the folder
COPY . /app

ENV TIMESCALEDB_PROVIDER="postgres"

ENV TIMESCALEDB_USER="tnga_iot"

ENV TIMESCALEDB_PASSWORD="Toyota_2026"

ENV TIMESCALEDB_HOST="10.82.126.43"

ENV TIMESCALEDB_DATABASE="tiei_test"

ENV LOGGER_CONFIGURATION_FILE="./configs/log.json"

ENV SECRET_KEY="09d25e094faa6ca2556c818166b7a9563b93f7099f6f0f4caa6cf63b88e8d3e7"

ENV MONGODB_USER="tngaIoT"

ENV MONGODB_PASSWORD="Toyota2022"

ENV MONGODB_HOST="10.82.126.72"

# start the server
CMD ["uvicorn", "main:APP", "--host", "0.0.0.0", "--port", "3003"]