FROM python:3.9
 # optional : ensure that pip is up to data
WORKDIR /app
RUN apt-get update && apt-get install -y --no-install-recommends build-essential libjpeg-dev && rm -rf /var/lib/apt/lists/*
RUN pip install --upgrade pip
COPY . /app
RUN pip install --no-cache-dir -r requirements.txt

  # lambda_function.handler 실행
CMD ["main.lambda_handler"]