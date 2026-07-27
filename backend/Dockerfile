FROM python:3.10

# set the working directory
WORKDIR /app

# install dependencies
COPY ./requirements.txt /app
RUN pip install --no-cache-dir --upgrade -r requirements.txt

# copy the scripts to the folder
COPY . /app

# Runtime configuration is supplied from backend/configs/.env
# via docker-compose. This keeps server credentials out of the image.

# start the server
CMD ["uvicorn", "main:APP", "--host", "0.0.0.0", "--port", "3003"]